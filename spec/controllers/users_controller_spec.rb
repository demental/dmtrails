require 'spec_helper'

describe UsersController do

  render_views
  before(:each) do
    @user = Factory(:user)
  end
  
  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Sign up")
    end
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should render the correct user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    it "should have the users name in title tag" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end  

    it "should have the users name in h1 tag" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end  
    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end    
  end
end
