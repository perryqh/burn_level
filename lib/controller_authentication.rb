module ControllerAuthentication
  def require_user
    if logged_in?
      session_accessed!
    else
      if request_contains_token_auth?
        authenticate_using_token
      else
        deny_access
      end
    end
  end

  def logged_in?
    current_user and !session_expired?
  end

  def deny_access
    request.xhr? ? deny_xhr_access : deny_html_access
  end

  def deny_html_access
    set_alert
    store_target_location
    redirect_to login_url, notice: 'Not authorized'
  end

  def deny_xhr_access
    set_alert
    response.headers['return_to'] = (request.referrer || "/")
    render :nothing => true, :status => 401
  end

  def session_accessed!
    session[:last_request] = Time.now
  end

  def session_expired?
    session[:last_request] && session[:last_request] < session_timeout_in_minutes.to_i.minutes.ago
  end

  def session_timeout_in_minutes
    60 * 24 * 2
  end

  def current_user
    @current_user ||= begin
      binding.pry
      if session[:user_id] && user = User.find(session[:user_id])
        user if authorized?(user)
      end
    end
  end


  def authorized?(user)
    if self.respond_to?(:required_roles)
      unless user.has_role?(self.required_roles)
        flash.alert = "Not authorized"
        return false
      end
    end
    true
  end

  def set_current_user(user)
    @current_user     = nil
    session[:user_id] = user.id
  end

  def user_signed_in?
    !!current_user
  end

  def redirect_to_target_or_default(default_url)
    redirect_to(session[:return_to] || default_url)
    session[:return_to] = nil
  end

  def store_target_location
    session[:return_to] = request.fullpath unless request.xhr?
  end

  def reset_timeout_timer
    session[:last_request] = nil
  end

  def set_alert
    if session_expired?
      flash.alert = "Your session has expired"
    else
      flash.alert = "You need to sign in before accessing this page"
    end
  end

  def request_contains_token_auth?
    request.authorization.try { |auth| auth.match /Token token=/ }
  end

  def authenticate_using_token
    authenticate_or_request_with_http_token do |token, options|
      user = User.find_by_api_token(token)

      if user and user.has_role?(required_roles)
        set_current_user user
        reset_timeout_timer
        true
      else
        false
      end
    end
  end
end