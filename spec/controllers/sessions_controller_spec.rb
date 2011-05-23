require 'spec_helper'

describe SessionsController do

  render_views
  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    it "souhld have the correct title" do
      get :new
      response.should have_selector('title')
    end
    it "has email field" do
      get :new
      response.should have_selector('input[name="session[email]"][type=text]')
    end
    it "has password field" do
      get :new
      response.should have_selector('input[name="session[password]"][type=password]')
    end
    it "has submit button" do
      get :new
      response.should have_selector('input[type=submit]')
    end      
  end


  describe "POST 'create'" do

     describe "invalid signin" do

       before(:each) do
         @attr = { :email => "email@example.com", :password => "invalid" }
       end

       it "should re-render the new page" do
         post :create, :session => @attr
         response.should render_template('new')
       end

       it "should have the right title" do
         post :create, :session => @attr
         response.should have_selector("title", :content => "Sign in")
       end

       it "should have a flash.now message" do
         post :create, :session => @attr
         flash.now[:error].should =~ /invalid/i
       end
     end

     describe "valid signin" do
       before(:each) do
         @user = Factory(:user)
         @attr = {:email => @user.email, :password => @user.password}
       end 
       it "should redirect to user show on success" do
          post :create, :session => @attr
          response.should redirect_to(user_path(@user))
       end
       it "should sign the user in" do
         post :create, :session => @attr
         controller.current_user.should == @user
         controller.should be_signed_in
       end   
     end 
   end
   describe "DELETE 'destroy" do
     before :each do
       test_sign_in Factory(:user)
     end
     it "should sign a user out" do
       delete :destroy
       controller.should_not be_signed_in
      end
     it "should redirect to home" do
       delete :destroy
       response.should redirect_to root_path
     end 
   end 
end
