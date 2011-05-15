require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com" }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    user = User.new(@attr.merge(:name=>""))
    user.should_not be_valid
  end


  it "should require an email" do
    user = User.new(@attr.merge(:email=>""))
    user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  it "should refuse not valid email" do
    emails = %w[not_valid_@email not_valid_email not_valid_email@]
    emails.each do |email|
      user = User.new(@attr.merge(:email=>email));
      user.should_not be_valid
    end
  end
  
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
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
