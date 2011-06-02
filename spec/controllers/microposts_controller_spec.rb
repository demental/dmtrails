require 'spec_helper'

describe MicropostsController do
  render_views

  describe "Access control" do
    it "should deny access to anon" do
      post :create
      response.should redirect_to signin_path
    end
    it "should deny access to destroy" do
      delete :destroy, :id => 1
      response.should redirect_to signin_path
    end
  end
  describe "POST 'create'" do
    before :each do
      @user = Factory(:user)
      test_sign_in @user
    end
    describe "failure" do
      before :each do
        @attr = {:content=>''}
      end
      it "should not create a micropost" do
        lambda do
          post :create, :micropost => @attr
        end.should_not change(Micropost, :count)
      end
      it "should render the home page" do
        post :create, :micropost => @attr
        response.should render_template 'pages/home'
      end
      it "should display error messages" do
        post :create, :micropost => @attr
        response.should have_selector('#error_explanation') 
      end
    end
    describe "success" do
      before :each do
        @attr = {:content => 'This is a valid post message'}
      end
      it "should create a new record" do
        lambda do
          post :create, :micropost => @attr
        end.should change(Micropost, :count).by(1)
      end
      it "should redirect to home page" do
        post :create, :micropost => @attr
        response.should redirect_to root_path 
      end
      it "should display a flash message" do
        post :create, :micropost => @attr
        flash[:success].should =~ /created/i
      end
    end
  end
  describe "DELETE 'destroy'" do

    describe "for an unauthorized user" do

      before(:each) do
        @user = Factory(:user)
        wrong_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(wrong_user)
        @micropost = Factory(:micropost, :user => @user)
      end

      it "should deny access" do
        delete :destroy, :id => @micropost
        response.should redirect_to(root_path)
      end
    end

    describe "for an authorized user" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        @micropost = Factory(:micropost, :user => @user)
      end

      it "should destroy the micropost" do
        lambda do 
          delete :destroy, :id => @micropost
        end.should change(Micropost, :count).by(-1)
      end
    end
  end

end
