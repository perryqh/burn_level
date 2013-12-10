require 'spec_helper'

describe SessionsController do
  let(:exchange_user_administrator_role) { create(:exchange_user_administrator_role).user }
  let(:user) { create(:user) }

  describe :create do
    before do
      controller.stub(env: {'omniauth.auth' => twitter_auth})
      post :create
    end
    specify { assigns(:user).id.should_not be_nil }
    specify { controller.send(:current_user).should eq(assigns(:user)) }
    specify { session[:user_id].should eq(assigns(:user).id) }
    specify { flash.notice.should eq('Signed in!') }
    specify { response.should redirect_to(root_url) }
  end

  describe :destroy do
    login_user :user

    before(:each) do
      delete :destroy
    end

    specify { controller.send(:current_user).should be_false }
    specify { response.should redirect_to(root_url) }
    specify { session[:user_id].should be_nil }
    specify { flash.notice.should eq('Signed out!') }
  end
end