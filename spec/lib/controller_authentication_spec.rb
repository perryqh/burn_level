require 'spec_helper'

class ControllerDummy
  attr_accessor :session, :user, :user_id, :redirect_to_path, :redirect_to_opts
  attr_accessor :login_path, :session_timeout_path
  attr_accessor :fullpath, :authorization, :xhr, :referrer
  include ControllerAuthentication
  include ActionController::HttpAuthentication::Token::ControllerMethods

  # Make all private methods public for testing purposes
  public *private_instance_methods.collect(&:to_sym)

  def redirect_to(path, opts={})
    self.redirect_to_path = path
    self.redirect_to_opts = opts
  end

  def headers
    @headers ||= {}
  end

  def login_url
    'http://login.url'
  end

  def controller
    self
  end

  def flash
    @flash ||= OpenStruct.new(alert: nil, notice: nil)
  end

  def request
    OpenStruct.new(fullpath: fullpath, xhr?: xhr, authorization: authorization, referrer: referrer)
  end
end

describe ControllerAuthentication do
  let(:login_path) { 'http://login.url' }
  let(:session_timeout_path) { '/timeout' }
  let(:controller_dummy) do
    ControllerDummy.new.tap do |cd|
      cd.session              = {}
      cd.login_path           = login_path
      cd.session_timeout_path = session_timeout_path
    end
  end

  let(:user) { create(:jock) }
  let(:signed_in_controller_dummy) { controller_dummy.tap { |cd| cd.session = {user_id: 'myid'}; cd.user = user } }

  describe 'current_user' do
    context 'with required roles set on dummy controller' do
      before do
        def controller_dummy.required_roles
          ['admin']
        end

        controller_dummy.set_current_user user
      end

      describe 'nothing in session' do
        specify { controller_dummy.current_user.should be_nil }
        specify { controller_dummy.user_signed_in?.should be_false }
      end

      describe 'current_user without necessary roles in session' do
        before do
          user.stub(roles: ['notadmin'])
        end
        specify { controller_dummy.current_user.should be_nil }
        specify { controller_dummy.user_signed_in?.should be_false }
        specify { controller_dummy.current_user; controller_dummy.flash.alert.should == "Not authorized" }
      end

      describe 'current_user with necessary roles in session' do
        let(:user) { create(:admin) }

        specify { controller_dummy.current_user.should eq(user) }
        specify { controller_dummy.user_signed_in?.should be_true }
        specify { controller_dummy.flash.alert.should be_nil }
      end
    end

    context 'without required roles' do
      describe 'nothing in session' do
        specify { controller_dummy.current_user.should be_nil }
        specify { controller_dummy.user_signed_in?.should be_false }
      end

      describe 'current_user in session' do
        let(:in_session_dummy) { controller_dummy.tap { |cd| cd.session = {user_id: user.id} } }
        specify { in_session_dummy.current_user.should eq(user) }
        specify { in_session_dummy.user_signed_in?.should be_true }
      end

      describe 'set_current_user' do
        it "should allow one to set the current user" do
          controller_dummy.set_current_user user
          controller_dummy.current_user.should eq(user)
        end
      end
    end
  end

  describe "logged_in?" do
    context "have a current user" do
      before { controller_dummy.stub(:current_user).and_return(true) }

      context "and session is not expired" do
        before { controller_dummy.stub(:session_expired?).and_return(false) }

        specify { controller_dummy.should be_logged_in }
      end
      context "and session is expired" do
        before { controller_dummy.stub(:session_expired?).and_return(true) }

        specify { controller_dummy.should_not be_logged_in }
      end
    end
    context "does not have a current user" do
      before { controller_dummy.stub(:current_user).and_return(nil) }

      context "and session is not expired" do
        before { controller_dummy.stub(:session_expired?).and_return(false) }

        specify { controller_dummy.should_not be_logged_in }
      end
      context "and session is expired" do
        before { controller_dummy.stub(:session_expired?).and_return(true) }

        specify { controller_dummy.should_not be_logged_in }
      end
    end
  end

  describe 'require_user' do
    context 'when a user is signed in' do
      before do
        Timecop.freeze(Time.now)
        controller_dummy.session[:user_id] = user.id
      end

      after do
        Timecop.return
      end

      it "should return true" do
        controller_dummy.require_user.should be_true
      end

      it "should call session_accessed!" do
        controller_dummy.should_receive(:session_accessed!)
        controller_dummy.require_user
      end

      it "should set last access time" do
        controller_dummy.require_user
        controller_dummy.session[:last_request].should == Time.now
      end

      context "but the session has expired" do
        before do
          controller_dummy.session_accessed!
          Timecop.freeze(Time.now + (controller_dummy.session_timeout_in_minutes.minutes + 1.minute))
        end

        it "sets the correct flash message" do
          controller_dummy.require_user
          controller_dummy.flash.alert.should == "Your session has expired"
        end
      end
    end

    context 'when a user is not signed in' do
      before do
        controller_dummy.stub(:logged_in?).and_return(false)
      end

      context "and the request contains a token authorization header" do
        before do
          controller_dummy.stub(:required_roles).and_return(["needed"])
          controller_dummy.authorization = "Token token=foo"
        end

        context "and the token is correct" do
          before do
            User.stub(:find_by_api_token).with("foo").and_return(user)
          end

          context "and the user has the correct role" do
            before { user.role = controller_dummy.required_roles.first }

            it "logs the user in" do
              controller_dummy.should_receive(:set_current_user).with(user)
              controller_dummy.require_user
            end

            it "resets the timeout timer" do
              controller_dummy.should_receive(:reset_timeout_timer)
              controller_dummy.require_user
            end
          end

          context "and the user does not have the correct role" do
            before { user.role = "not allowed" }

            it "returns a 401 status code" do
              controller_dummy.should_receive(:render).with(hash_including(status: :unauthorized))
              controller_dummy.require_user
            end
          end
        end

        context "and the token is incorrect" do
          before do
            User.stub(:find_by_credentials).with(token: "foo").and_return(nil)
          end

          it "returns a 401 status code" do
            controller_dummy.should_receive(:render).with(hash_including(status: :unauthorized))
            controller_dummy.require_user
          end
        end
      end

      context "and the request does not contain a token authorization header" do
        it "should redirect to login_path" do
          controller_dummy.require_user
          controller_dummy.redirect_to_path.should == login_path
        end

        it "should store_target_location" do
          controller_dummy.should_receive(:store_target_location)
          controller_dummy.require_user
        end

        it "sets the correct flash message" do
          controller_dummy.require_user
          controller_dummy.flash.alert.should == "You need to sign in before accessing this page"
        end

        context "and a html request is made" do
          before { controller_dummy.xhr = false }

          it "should call deny_html_access" do
            controller_dummy.should_receive(:deny_html_access)
            controller_dummy.require_user
          end
        end

        context "and an xhr request is made" do
          let(:headers) { {} }

          before do
            controller_dummy.xhr =true
            controller_dummy.stub_chain(:response, :headers).and_return(headers)
            controller_dummy.stub(:render)
          end

          it "should call deny_xhr_access" do
            controller_dummy.should_receive(:deny_xhr_access)
            controller_dummy.require_user
          end

          context "when there is a request.referrer" do
            before do
              controller_dummy.referrer = "returnHere!"
            end

            it "should set the return_to header" do
              controller_dummy.require_user
              controller_dummy.response.headers['return_to'].should == controller_dummy.request.referrer
            end
            it "should call render with a 401" do
              controller_dummy.should_receive(:render).with({:nothing => true, :status => 401})
              controller_dummy.require_user
            end
          end

          context "when there is not a request.referrer" do
            it "should set the return_to header" do
              controller_dummy.require_user
              controller_dummy.response.headers['return_to'].should == "/"
            end
            it "should call render with a 401" do
              controller_dummy.should_receive(:render).with({:nothing => true, :status => 401})
              controller_dummy.require_user
            end
          end
        end

        it "should call deny_access" do
          controller_dummy.should_receive(:deny_access)
          controller_dummy.require_user
        end
      end
    end

  end
  describe 'session_expired?' do
    context "without last_request in session" do
      before { controller_dummy.session[:last_request] = nil }

      it "should not expire" do
        Timecop.travel((controller_dummy.session_timeout_in_minutes).minutes.from_now) do
          controller_dummy.should_not be_a_session_expired
        end
      end
    end

    context "with last_request in session" do
      before { controller_dummy.session_accessed! }

      it "should expire" do
        Timecop.travel((controller_dummy.session_timeout_in_minutes).minutes.from_now) do
          controller_dummy.should be_a_session_expired
        end
      end

      it "should redirect to login" do
        Timecop.travel(1.minutes.from_now) do
          controller_dummy.should_not be_a_session_expired
        end
      end
    end
  end

  describe 'redirect_to_target_or_default' do
    it "should use the default_url if return_to is not set" do
      controller_dummy.redirect_to_target_or_default 'foo'
      controller_dummy.redirect_to_path.should == 'foo'
    end

    it "should use return_to if set" do
      controller_dummy.fullpath = 'fullpath'
      controller_dummy.store_target_location

      controller_dummy.redirect_to_target_or_default 'foo'
      controller_dummy.redirect_to_path.should == 'fullpath'
    end
  end

  describe 'store_target_location' do
    before do
      controller_dummy.fullpath = 'fullpath'
    end

    context 'when an non-xhr request is made' do
      it "should save the fullpath to the session" do
        controller_dummy.store_target_location
        controller_dummy.session[:return_to].should == 'fullpath'
      end
    end


    context 'when an xhr request is made' do
      before do
        controller_dummy.fullpath = "fullpath"
        controller_dummy.xhr      = true
      end

      it "should NOT save the fullpath to the session" do
        controller_dummy.store_target_location
        controller_dummy.session[:return_to].should_not == 'fullpath'
      end
    end
  end

  describe "reset_timeout_timer" do
    before do
      controller_dummy.session[:last_request] = "somedata"
      controller_dummy.reset_timeout_timer
    end

    specify { controller_dummy.session[:last_request].should be_nil }
  end
end
