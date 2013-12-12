module Api
  class ApiController < ApplicationController
    before_filter :require_user

    def required_roles
      User::ROLES
    end
  end
end