require 'spec_helper'

describe WelcomeController do
  describe :index do
    before do
      get :index
    end
    specify { response.should render_template(:index) }
  end
end