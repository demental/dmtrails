class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
    
  def new
    @title = "Sign up"
    @user = User.new
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

end
