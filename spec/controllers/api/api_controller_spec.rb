require 'spec_helper'

describe Api::ApiController do
  specify { controller.required_roles.should eq(User::ROLES) }
end