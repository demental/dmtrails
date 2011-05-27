class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update] 
  before_filter :correct_user, :only => [:edit, :update] 
  before_filter :admin_user,   :only => [:destroy] 
  before_filter :anonymous,    :only => [:new, :create]
  def index
    @title = "All users"
    @users = User.paginate( :page=>params[:page] )
  end  

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
    
  def new
    @title = "Sign up"
    @user = User.new
  end
  def edit
    @title = "Edit user"
  end  
  def update
    if(@user.update_attributes(params[:user]))
      flash[:success] = "Profile updated"
      redirect_to @user
    else  
      @title = "Edit user"
      render :edit
    end  
  end  
  def create
    @user = User.new params[:user]
    
    if(@user.save)
      flash[:success] = 'welcome to the sample app'
      sign_in @user
      redirect_to @user
    else
      @user.password=""
      @user.password_confirmation=""
      @title = 'Sign up'
      render :new
    end      
  end

  def destroy
    user = User.find(params[:id])
    if current_user? user
      redirect_to root_path
    else
      user.destroy
      flash[:success]= "User deleted"
      redirect_to users_path
    end  
  end  
  
  
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