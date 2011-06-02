class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  private
    def authenticate
      deny_access unless signed_in?
    end  
    def anonymous
      redirect_to root_path unless !signed_in?
    end  
    def admin_user
      redirect_to root_path unless admin?
    end  
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user? @user
    end  
end
