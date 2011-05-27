require 'spec_helper'

describe UsersController do

  render_views
  
  describe "GET 'index'" do
    describe "for anon users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
      end  
    end  
    describe "for authenticated users" do
      before :each do
        @user = Factory(:user)
        test_sign_in @user
        second = Factory(:user, :name=>"bob",:email=>'demaj@fr.fr')
        third = Factory(:user, :name=>"joe", :email=>'fekj@frge.fr')
        
        @users = [@user, second, third]
      end  
      it "should be successfull" do
        get :index
        response.should be_successful
      end
      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All users")
      end      
      it "should display the list of users" do
        get :index
        @users.each do |user|
          response.should have_selector("li", :content=>user.name)
        end
      end  
      it "should have an element for each user" do
        get :index
        @users[0..2].each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end
      describe "pagination" do
        before :each do
          50.times do |n|
            @users << Factory(:user, :email => Factory.next(:email))
          end  
        end
        it "should display pagination links" do
          get :index
          response.should have_selector("div.pagination")
          response.should have_selector("a", :href=>users_path(:page=>2))
        end
        it "should display links 1and 2 for 50 users" do
          get :index
          response.should_not have_selector("a", :href=>users_path(:page=>3))
        end
        it "should NOT have delete links" do
          get :index
          response.should_not have_selector("a",:content => 'Delete')
        end

      end  
      describe "admin" do
        before :each do
          @user.toggle! :admin
        end
        it "should have delete links" do
          get :index
          response.should have_selector("a[data-method=delete]", :href => user_path(@users[1]))
        end

        it "should not have delete link for himself" do
          get :index
          response.should_not have_selector("a[data-method=delete]", :href => user_path(@user))
        end
      end    
    end    
  end  
  describe "DELETE 'destroy'" do
    before :each do
      @user = Factory(:user)
      @second = Factory(:user, :email=>'other@email.fr')
      test_sign_in @user
    end
    it "should redirect to root path" do
      delete :destroy, :id=> @second
      response.should redirect_to root_path
    end    
    it "should not delete any user" do
      lambda do
        delete :destroy, :id=> @second
      end.should_not change(User,:count)  
    end
    describe "admin user" do
      before :each do
        @user.toggle! :admin
      end  
      it "should redirect to users list" do
        delete :destroy, :id=> @second
        response.should redirect_to users_path
      end  
      it "should display a flash message" do
        delete :destroy, :id=> @second
        flash[:success].should =~ /deleted/i
      end  
      it "should delete one user" do
        lambda do
          delete :destroy, :id=> @second
        end.should change(User,:count).by(-1)  
      end
      it "should not be able to delete himself" do
        lambda do
          delete :destroy, :id=> @user
        end.should_not change(User,:count)
      end
    end
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
    it "should have a name field" do
      get :new
      response.should have_selector("input[name='user[name]'][type='text']")
    end    
    it "should have an email field" do
      get :new
      response.should have_selector("input[name='user[email]'][type='text']")
    end
    it "should have a password field" do
      get :new
      response.should have_selector("input[name='user[password]'][type='password']")
    end    
    it "should have a confirmation field" do
      get :new
      response.should have_selector("input[name='user[password_confirmation]'][type='password']")
    end    
    it "should have a submit button" do
      get :new
      response.should have_selector("input[type='submit']")
    end    
    it "should not be accessible by signed in users" do
      user = Factory(:user)
      test_sign_in user
      get :new
      response.should redirect_to root_path
    end
      
  end
  
  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)
    end  
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
    it "should display the users microposts" do
      mp1 = @user.microposts.create :content => 'foo bar'
      mp2 = @user.microposts.create :content => 'bar baz'
      get :show, :id => @user

      response.should have_selector('span.content', :content => mp1.content)
      response.should have_selector('span.content', :content => mp2.content)
    end
  end
  describe "POST 'create'" do
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
    it "should reset password on failure" do
      post :create, :user => @notvalidattr.merge({:password=>"test123",:password_confirmation=>'test123'})
      assigns(:user).password.should be_empty
    end
    it "should reset password on failure" do
      post :create, :user => @notvalidattr.merge({:password=>"test123",:password_confirmation=>'test123'})
      assigns(:user).password_confirmation.should be_empty      
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
      it "should sign the user in" do
        post :create, :user => @validattr
        controller.should be_signed_in
      end
      it "should have a welcome message" do
        post :create, :user => @validattr
        flash[:success].should =~ /welcome to the sample app/i
      end            
    end  
    describe "signed in users" do
      it "should not be accessible" do
        user = Factory(:user)
        test_sign_in user
        get :create, :user => @validattr
        response.should redirect_to root_path
      end
    end  
  end  
  
  describe "GET 'edit'" do
    before :each do
      @user = Factory('user')
    end  
    describe "for anon users" do
      it "should redirect to signin path" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end        
    end  
    describe "for authenticated users" do
      before :each do
        test_sign_in @user
      end  
      it "should be success" do
        get :edit, :id => @user
        response.should be_success
      end  
      it "should have the right title" do
        get :edit, :id => @user
        response.should have_selector("title", :content => "Edit user")
      end  
      it "should have a link to change gravatar" do
        get :edit, :id => @user
        response.should have_selector("a", :href => gravatar_url,
                                          :content => "change")
      end        
    end
    describe "for other user" do
      before :each do
        test_sign_in @user
        @wronguser = Factory(:user, :email => 'user2@email.fr')
      end  
      it "should redirect to root if wrong user" do
        get :edit, :id => @wronguser
        response.should redirect_to(root_path)
      end      
      it "should redirect to root if wrong user" do
        put :update, :id => @wronguser, :user => {}
        response.should redirect_to(root_path)
      end      

    end  
    describe "PUT 'update'" do
      before :each do
        test_sign_in @user
        @attr = {:email=>'new@email.fr',:name=>'new_name',:password=>'new_password',:password_confirmation=>'new_password'}
      end
      it "should update user attributes" do
        put :update, :id=> @user, :user => @attr
        @user.reload
        @user.name.should == @attr[:name]
        @user.email.should == @attr[:email]
      end  
    end
  end
  
end
