require 'spec_helper'

describe "Sessions" do
  describe "Sign in" do
    describe "failure" do
      it "should reload if no info provided" do
        visit '/signin'
        fill_in "session_email", :with=>''
        fill_in "session_password", :with=>''
        click_button
        response.should render_template('sessions/new')
      end
    end  
  end
end
