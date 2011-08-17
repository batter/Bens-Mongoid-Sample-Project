require 'spec_helper'

describe RelationshipsController do
  describe "access control" do

    it "should require signin for create" do
      post :create
      response.should redirect_to(new_user_session_path)
    end

    it "should require signin for destroy" do
      delete :destroy, :id => 1
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "POST 'create'" do

    before(:each) do
      sign_in @user = Factory(:user)
      @followed = Factory(:user, :email => Factory.next(:email))
    end

    it "should create a relationship" do
      expect {
        post :create, :relationship => { :followed_id => @followed.to_param }
        response.should be_redirect
      }.to change(Relationship, :count).by(1)
    end
    
    it "should create a relationship using Ajax" do
      expect {
        xhr :post, :create, :relationship => { :followed_id => @followed.to_param }
        response.should be_success
      }.to change(Relationship, :count).by(1)
    end
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      sign_in @user = Factory(:user)
      @followed = Factory(:user, :email => Factory.next(:email))
      @user.follow!(@followed)
      @relationship = @user.following_relations.find_or_initialize_by(:followed_id => @followed.to_param)
    end

    it "should destroy a relationship" do
      expect {
        delete :destroy, :id => @relationship.to_param
        response.should be_redirect
      }.to change(Relationship, :count).by(-1)
    end
    
    it "should destroy a relationship using Ajax" do
      expect {
        xhr :delete, :destroy, :id => @relationship.to_param
        response.should be_success
      }.to change(Relationship, :count).by(-1)
    end
  end
end
