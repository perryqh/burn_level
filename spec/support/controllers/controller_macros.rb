module ControllerMacros
  def login_user(user_role_type=:jock)
    before(:each) do
      @current_user = create(user_role_type)
      session[:user_id] = @current_user.id
    end
  end
end