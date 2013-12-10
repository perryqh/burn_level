require 'spec_helper'

describe 'external redirection' do
  it 'redirects to root' do
    get '/auth/failure'
    response.should redirect_to('/')
  end
end
