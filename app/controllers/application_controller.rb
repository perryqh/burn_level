class ApplicationController < ActionController::Base
  include ControllerAuthentication
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def root_url
    return api_v1_routines_url if current_user
    login_url
  end

  def login_url
    '/'
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render nothing: true, status: 404
  end

  private

  helper_method :current_user, :root_url
end
