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
  def current_user?(user)
    current_user == user
  end
  def admin?
    current_user.admin?
  end  
  def deny_access
    store_path
    redirect_to signin_path, :notice => "You must sign in to access this page"
  end
  def redirect_back_or(path)
    redirect_to(session[:originpath] || path)
    clear_originpath
  end      
  private
  def clear_originpath
    session[:originpath] = nil
  end  
  def store_path
    session[:originpath] = request.fullpath
  end
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
