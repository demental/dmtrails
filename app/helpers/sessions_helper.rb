module SessionsHelper

  def sign_in(user)
    session[:remember_token] = user.id
    self.current_user = user
  end
  def sign_out
    session[:remember_token] = nil
    self.current_user = nil
  end
  def current_user=(user)
    @current_user = user
  end
  def current_user  
    @current_user ||= user_from_remember_token
  end

  private
  
  def user_from_remember_token
    User.find_by_id(remember_token)
  end  
  def remember_token
    session[:remember_token] || nil
  end

  def signed_in?
    !current_user.nil?
  end  
end
