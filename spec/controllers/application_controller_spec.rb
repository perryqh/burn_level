require 'spec_helper'

describe ApplicationController do
  describe :root_url do
    specify { controller.root_url.should eq('/') }
    context 'with user' do
      login_user :user
      specify { controller.root_url.should eq(api_v1_routines_url) }
    end
  end
end