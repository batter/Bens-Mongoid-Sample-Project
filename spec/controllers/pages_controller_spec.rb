require 'spec_helper'

describe PagesController do
  render_views
  
  before (:each) do
    @base_title = "Ben's Sample App"
  end

  describe "GET 'home'" do
    it "should be successful" do
      get :home
      response.should be_success
    end
    
    it "should have the right title" do
      get :home
      response.should have_selector("title",
                        :content => @base_title + " | Home")
    end
    
    describe "for non-signed-in users" do
      it "should have a welcome screen" do
        get :home
        response.should have_selector("h1", :content => "Welcome to Ben's Sample App")
        response.should have_selector("a", :href => new_user_registration_path,
                         :class => "signup_button round", :content => "Sign up now!")
      end
    end
    
    describe "for signed-in users" do
      
      before (:each) do
        sign_in @user = Factory(:user)
        
        @posts = []
        30.times do
          @posts << Factory(:micropost, :user => @user, :content => Factory.next(:pcontent))
        end
      end
      
      it "should have a form for the user to create microposts" do
        get :home
        response.should have_selector("h1", :content => "What's up?")
        response.should have_selector("textarea", :id => "micropost_content",
                           :maxlength => "140")
        response.should have_selector("input", :type => "submit", :value => "Submit")
      end
      
      it "should have a feed for the user" do
        get :home
        @posts[0..2].each do |post|
          response.should have_selector("span", :class => "user", :content => post.user.name)
          response.should have_selector("span", :class => "content", :content => post.content)
        end
      end
      
      it "should paginate feed items" do
        get :home
        response.should have_selector("nav.pagination")
        response.should have_selector("a", :href => "/?page=2",
                                           :content => "2")
        response.should have_selector("a", :href => "/?page=2",
                                           :content => "Next")
        response.should have_selector("a", :href => "/?page=2",
                                           :content => "Last")
      end
      
      describe "sidebar" do
        
        it "should have a link to the user's profile page" do
          get :home
          response.should have_selector("a", :href => user_path(@user), :content => @user.name)
        end
        
        it "should have a pluralized link to the user's microposts" do
          get :home
          response.should have_selector("a", :href => user_microposts_path(@user), :content => "0 microposts")
          Factory(:micropost, :user => @user, :content => Factory.next(:pcontent))
          get :home
          response.should have_selector("a", :href => user_microposts_path(@user), :content => "1 micropost")
          Factory(:micropost, :user => @user, :content => Factory.next(:pcontent))
          get :home
          response.should have_selector("a", :href => user_microposts_path(@user), :content => "2 microposts")
        end
        
        it "should have the right follower/following counts" do
          other_user = Factory(:user, :email => Factory.next(:email))
          other_user.follow!(@user)
          get :home
          response.should have_selector("a", :href => following_user_path(@user),
                                             :content => "0 following")
          response.should have_selector("a", :href => followers_user_path(@user),
                                             :content => "1 follower")
        end
      end
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get :about
      response.should be_success
    end
    
    it "should have the right title" do
      get :about
      response.should have_selector("title",
                        :content => @base_title + " | About")
    end
  end
  
  describe "GET 'help'" do
    it "should be successful" do
      get :help
      response.should be_success
    end
    
    it "should have the right title" do
      get :help
      response.should have_selector("title",
                        :content => @base_title + " | Help")
    end
  end

end
