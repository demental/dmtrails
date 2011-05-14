require 'spec_helper'

describe User do
  it "saves to database" do
    u = User.new({:name => "demental", :email => "demental@test.com"})
    u.save
    
    ut = User.find({:name => "demental"})
    shouldnt ut.id nil
  end  
end
