require 'spec_helper'

describe PagesController do
  render_views
  before(:each) do
    #
    # Define @base_title here.
    #
    @base_title = "Ruby on Rails Tutorial Sample App | "
  end
  describe "GET 'home'" do
    it "should be successful" do
      get :home
      response.should be_success
    end
    it "should have the right title" do
      get 'home'
      response.should have_selector("title", 
                      :content=>@base_title + "Home")
    end  
    describe "feed" do
      before :each do
        @user = Factory(:user)
        test_sign_in @user
        10.times do |n|
          Factory(:micropost, :user => @user)
        end
      end
      it "should display users feed" do
        get 'home'
        assigns[:feed_items].first.should == @user.feed.first
      end
    end
    describe "micropost form" do
      before :each do
        @user = Factory :user
        test_sign_in @user
      end
      it "should have a 'countable' textarea" do
        get 'home'
        response.should have_selector 'textarea.countable'
      end 
    end
    describe "micropost pagination" do
      before :each do
        @user = Factory :user
        test_sign_in @user
      end
      it "should display micropost pagination" do
        50.times do |n|
          @user.microposts.create :content=>"Content #{n}"
        end
        get :home
        response.should have_selector('a', :href => root_path(:page=>2))
      end
      it "should not display pagination if too few posts" do
        
        5.times do |n|
          @user.microposts.create :content=>"Content #{n}"
        end
      end
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
    it "should have the right title" do
      get 'about'
      response.should have_selector("title", 
                      :content=>@base_title + "About")
    end  
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
    it "should have the right title" do
      get 'contact'
      response.should have_selector("title", 
                      :content=>@base_title + "Contact")
    end  
  end

  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end
    it "should have the right title" do
      get 'help'
      response.should have_selector("title", 
                      :content=>@base_title + "Help")
    end  
  end
end
