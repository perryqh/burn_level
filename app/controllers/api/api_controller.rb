module Api
  class ApiController < ApplicationController
    before_filter :require_user
  end
end