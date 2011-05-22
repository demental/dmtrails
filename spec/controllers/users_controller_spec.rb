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
  describe "POST 'new'" do
    before :each do
      @notvalidattr = {:name=>'',:email=>'',:password=>'',:password_confirmation=>''}
    end
    it "should show reload form if not valid" do
      post :create, :user => @notvalidattr
      response.should have_selector("title", :content => 'Sign up')
    end
    it "should render the 'new' page" do
      post :create, :user => @notvalidattr
      response.should render_template('new')
    end
    it "should not create a user if not valid" do
      lambda do
        post :create, :user => @notvalidattr
      end.should_not change(User, :count)
    end    

    describe 'success' do
      before :each do
        @validattr = {:name=>'demental',:email=>'demental@sat2way.com',:password=>'123456789',:password_confirmation=>'123456789'}
      end
      it "should create a user if valid" do
        lambda do
          post :create, :user => @validattr
        end.should change(User, :count).by(1)
      end
      it "should redirect to the user show page" do
        post :create, :user => @validattr
        response.should redirect_to(user_path(assigns(:user)))
      end  
      it "should have a welcome message" do
        post :create, :user => @validattr
        flash[:success].should =~ /welcome to the sample app/i
      end            
    end

  
  end  
end
