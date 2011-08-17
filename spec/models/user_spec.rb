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

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 129
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end
  
  describe "admin attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle_admin!
      @user.should be_admin
    end
  end
  
  describe "micropost associations" do

    before(:each) do
      @user = User.create(@attr)
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end

    it "should have a microposts attribute" do
      @user.should respond_to(:microposts)
    end
    
    it "should have the right microposts in the right order" do
      @user.microposts.should == [@mp2, @mp1]
    end
    
    it "should destroy associated microposts when destroyed" do
      @user.destroy
      [@mp1, @mp2].each do |micropost|
        #Micropost.find(micropost.id).should be_nil
        expect {
          Micropost.find(micropost.to_param)
        }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end
    
    describe "status feed" do

      it "should have a feed" do
        @user.should respond_to(:feed)
      end

      it "should include the user's microposts" do
        @user.feed.include?(@mp1).should be_true
        @user.feed.include?(@mp2).should be_true
      end

      it "should not include a different user's microposts" do
        mp3 = Factory(:micropost,
                      :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.include?(mp3).should be_false
      end
      
      it "should include the microposts of followed users" do
        followed = Factory(:user, :email => Factory.next(:email))
        mp3 = Factory(:micropost, :user => followed)
        @user.follow!(followed)
        @user.feed.should include(mp3)
      end
    end
  end
  
  describe "relationships" do
    
    before(:each) do
      @user = User.create!(@attr)
      @followed = Factory(:user)
    end
    
    it "should have a following_relationships method" do
      @user.should respond_to(:following_relations)
    end
    
    it "should have a following method" do
      @user.should respond_to(:following)
    end
    
    it "should have a following? method" do
      @user.should respond_to(:following?)
    end

    it "should have a follow! method" do
      @user.should respond_to(:follow!)
    end

    it "should follow another user" do
      @user.follow!(@followed)
      @user.should be_following(@followed)
    end

    it "should include the followed user in the following array" do
      @user.follow!(@followed)
      @user.following.should include(@followed)
    end
    
    it "should have an unfollow! method" do
      @followed.should respond_to(:unfollow!)
    end

    it "should unfollow a user" do
      @user.follow!(@followed)
      @user.unfollow!(@followed)
      @user.should_not be_following(@followed)
    end
    
    it "should have a followers_relationships method" do
      @user.should respond_to(:followers_relations)
    end

    it "should have a followers method" do
      @user.should respond_to(:followers)
    end

    it "should include the follower in the followers array" do
      @user.follow!(@followed)
      @followed.followers.should include(@user)
    end
    
    it "should destroy following relationships when destroyed" do
      relationship = @user.follow!(@followed)
      @user.destroy
      expect {
        Relationship.find(relationship.to_param)
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
    
    it "should destroy followed relationships when destroyed" do
      relationship = @user.follow!(@followed)
      @followed.destroy
      @user.should_not be_following(@followed)
      expect {
        Relationship.find(relationship.to_param)
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
  end
end