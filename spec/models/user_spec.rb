require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :name => "Example User", 
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge({:password =>"",:password_confirmation =>""}))
      .should_not be_valid
    end  
    it "should have same password and confirmation" do
      User.new(@attr.merge({:password =>"baz"}))
      .should_not be_valid
    end  
    it "should reject short passwords" do
      shortPassword = "a"*4
      User.new(@attr.merge({:password =>shortPassword, :password_confirmation =>shortPassword}))
      .should_not be_valid
    end  
    it "should reject long passwords" do
      longPassword = "a"*41
      User.new(@attr.merge({:password =>longPassword, :password_confirmation =>longPassword}))
      .should_not be_valid
    end      
  end  
  
  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end
    it "should have an encrypted_password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    it "should not have blank encrypted_password" do
      @user.encrypted_password.should_not be_blank
    end
    it "should be true if the passwords match" do
      @user.has_password?(@attr[:password]).should be_true
    end    
    it "should be false if the passwords don't match" do
      @user.has_password?("invalid").should be_false
    end
    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        User.authenticate(@attr[:email], "wrongpass")
        .should be_nil
      end

      it "should return nil for an email address with no user" do
        User.authenticate("bar@foo.com", @attr[:password])
        .should be_nil
      end

      it "should return the user on email/password match" do
        User.authenticate(@attr[:email], @attr[:password])
        .should == @user
      end
    end    
  end
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    User.new(@attr.merge(:name=>""))
    .should_not be_valid
  end


  it "should require an email" do
    User.new(@attr.merge(:email=>""))
    .should_not be_valid
  end

  it "should accept valid email addresses" do
    %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    .each do |address|
      User.new(@attr.merge(:email => address))
      .should be_valid
    end
  end
  it "should refuse not valid email" do
    %w[not_valid_@email not_valid_email not_valid_email@]
    .each do |email|
      User.new(@attr.merge(:email=>email))
      .should_not be_valid
    end
  end
  
  it "should reject names that are too long" do
    long_name = "a" * 51
    User.new(@attr.merge(:name => long_name))
    .should_not be_valid
  end  
  
  it "should reject duplicates emails" do
    user = User.create!(@attr)
    duplicate_user = User.new(@attr.merge(:name=>'other name'))
    duplicate_user.should_not be_valid
  end  
  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
end
