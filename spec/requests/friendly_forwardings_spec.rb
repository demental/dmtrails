require 'spec_helper'

describe "FriendlyForwardings" do
    before :each do
      @user = Factory(:user)
    end
    it "should redirect to correct page after sign in" do
      visit edit_user_path(@user)
      fill_in :email, :with => @user.email
      fill_in :password, :with => @user.password
      click_button
      response.should render_template('users/edit')
    end
end
