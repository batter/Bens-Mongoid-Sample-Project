require 'spec_helper'

describe "Following" do
  
  before(:each) do
    integration_sign_in @user = Factory(:user)
    @other_user = Factory(:user, :email => Factory.next(:email))
  end
  
  describe "Follow Link" do
    
    it "should follow a user when the follow button is clicked" do
      expect {
        visit user_path(@other_user)
        response.should render_template('users/show')
        click_button "Follow"
      }.to change(Relationship, :count).by(1)
    end
    
    it "should unfollow a user when the follow button is clicked" do
      @user.follow!(@other_user)
      expect {
        visit user_path(@other_user)
        response.should render_template('users/show')
        click_button "Unfollow"
      }.to change(Relationship, :count).by(-1)
    end
  end
  
end