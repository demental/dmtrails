require 'spec_helper'

describe "LayoutLinks" do
  describe "GET /layout_links" do
    it "should have a Home page at '/'" do
      get '/'
      response.should have_selector('title', :content => "Home")
    end
    it "should have a Contact page at '/contact'" do
      get contact_path
      response.should have_selector('title', :content => "Contact")
    end
    
    it "should have an About page at '/about'" do
        visit about_path
      response.should have_selector('title', :content => "About")
    end
    
    it "should have a Help page at '/help'" do
        visit help_path
      response.should have_selector('title', :content => "Help")
    end     
    it "should have a signup page at '/signup'" do
        visit signup_path
        response.should have_selector('title', :content => "Sign up")
    end    
    it "should have a sign in link for anon users" do
        visit root_path
        response.should have_selector('a', :href=> signin_path)
    end
    
    describe "when logged in" do
      before :each do
        @user = Factory('user')
        integration_sign_in @user
      end
      it "should have a 'sign out' link" do
        visit root_path
        response.should have_selector('a', :href => signout_path)
      end
      it "should have a 'profile' link" do
        visit root_path
        response.should have_selector('a', :href => user_path(@user))
      end    
    end  
  end
end
