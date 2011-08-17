require 'spec_helper'

describe UsersController do
  render_views

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {:name => "Ben Fresh", :email => "ben.fresh@gmail.com", :password => "foobar", :password_confirmation => "foobar"}
  end
  
  before (:each) do
    @base_title = "Ben's Sample App"
  end

  describe "GET index" do
    
    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(new_user_session_path)
        flash[:alert].should =~ /You need to sign in or sign up before continuing./
      end
    end
    
    describe "for signed-in users" do
      before (:each) do
        sign_in @user = Factory(:user)
        
        @users = [@user]
        30.times do
          @users << Factory(:user, :email => Factory.next(:email))
        end
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector("title",
                          :content => @base_title + " | User List")
      end
      
      it "should have an element for each user" do
        get :index
        @users[0..2].each do |user|
          response.should have_selector("td", :content => user.name)
          response.should have_selector("td", :content => user.email)
        end
      end
      
      it "should paginate users" do
        get :index
        response.should have_selector("nav.pagination")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "2")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "Next")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "Last")
      end
    end
    
    describe "as an admin user" do
      before(:each) do
        sign_in admin = Factory(:user, :email => "admin@example.com", :admin => true)
        
        @users = [Factory(:user)]
        9.times do
          @users << Factory(:user, :email => Factory.next(:email))
        end
        @users << admin
      end
      
      it "should have links to edit & delete a user" do
        get :index
        @users[0..2].each do |user|
          response.should have_selector("td", :content => user.name)
          response.should have_selector("td a", :href => edit_user_path(user),
                                                  :content => "Edit")
          response.should have_selector("td a", :href => "/users/#{user.id}",
                                                  :content => "Delete")
        end
      end
      
      it "should not have links to delete admin users" do
        get :index
        @users.last do |user|
          response.should have_selector("td a", :href => edit_user_path(user),
                                                  :content => "Edit")
          response.should_not have_selector("td a", :href => "/users/#{user.id}",
                                                  :content => "Delete")
        end
      end
      
    end
  end

  describe "GET show" do
    before (:each) do
      @user = Factory(:user)
    end
    
    it "should be successful" do
      get :show, :id => @user.to_param
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user.to_param
      assigns(:user).should eq(@user)
    end
    
    it "should have the right title" do
      get :show, :id => @user.to_param
      response.should have_selector("title",
                        :content => @base_title + " | #{@user.name}")
    end
    
    it "should include the user's name" do
      get :show, :id => @user.to_param
      response.should have_selector("h2", :content => @user.name)
    end
    
    it "should show the user's microposts" do
      mp1 = Factory(:micropost, :user => @user, :content => "Foo bar")
      mp2 = Factory(:micropost, :user => @user, :content => "Baz quux")
      get :show, :id => @user.to_param
      response.should have_selector("span.content", :content => mp1.content)
      response.should have_selector("span.content", :content => mp2.content)
    end
    
    describe "sidebar" do
      
      before(:each) do
        @attr1 = { :content => "Lorem ipsum dolor sit amet"}
        @attr2 = { :content => "I hope that this test works!"}
        get :show, :id => @user.to_param
      end
      
      it "should have the user's name" do
        response.should have_selector('span', :content => "Name #{@user.name}")
      end
      
      it "should have the user's URL" do
        response.should have_selector('span', :content => "URL #{user_path(@user)}")
        response.should have_selector('a', :href => user_path(@user), :content => user_path(@user))
      end
      
      it "should show the correct micropost count" do 
        response.should have_selector('span', :content => "Microposts 0") 
        Factory(:micropost, :user => @user, :content => "Foo bar")
        get :show, :id => @user.to_param
        response.should have_selector('span', :content => "Microposts 1")
        Factory(:micropost, :user => @user, :content => "Lorem ipsum")
        get :show, :id => @user.to_param
        response.should have_selector('span', :content => "Microposts 2") 
      end
    end
  end
  
  describe "DELETE 'destroy'" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user.to_param
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "as a non-admin user" do
      it "should protect the page" do
        sign_in @user
        delete :destroy, :id => @user.to_param
        response.should redirect_to(root_path)
      end
    end

    describe "as an admin user" do
      before(:each) do
        sign_in Factory(:user, :email => "admin@example.com", :admin => true)
      end

      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user.to_param
        end.should change(User, :count).by(-1)
      end

      it "should redirect to the users page" do
        delete :destroy, :id => @user.to_param
        response.should redirect_to(users_path)
      end
    end
  end

  describe "GET edit (admin mode)" do
    
    before(:each) do
      @user = Factory(:user)
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user.to_param
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "as a non-admin user" do
      it "should protect the page" do
        sign_in @user
        delete :destroy, :id => @user.to_param
        response.should redirect_to(root_path)
      end
    end

    describe "as an admin user" do
      before(:each) do
        sign_in Factory(:user, :email => "admin@example.com", :admin => true)
      end
      
      it "assigns the requested user as @user" do
        get :edit, :id => @user.to_param
        assigns(:user).should eq(@user)
      end
      
      it "should have the right title" do
        get :edit, :id => @user.to_param
        response.should have_selector("title",
                          :content => @base_title + " | Edit #{@user.name}")
      end
    end
    
  end

  describe "PUT update (admin mode)" do
    before(:each) do
      @user = Factory(:user)
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user.to_param
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "as a non-admin user" do
      it "should protect the page" do
        sign_in @user
        delete :destroy, :id => @user.to_param
        response.should redirect_to(root_path)
      end
    end

    describe "as an admin user" do
      before(:each) do
        sign_in Factory(:user, :email => "admin@example.com", :admin => true)
      end
    
      describe "with valid params" do
        it "updates the requested user" do
          # Assuming there are no other users in the database, this
          # specifies that the User created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          User.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => @user.to_param, :user => {'these' => 'params'}
        end
  
        it "assigns the requested user as @user" do
          put :update, :id => @user.to_param, :user => valid_attributes
          assigns(:user).should eq(@user)
        end
  
        it "redirects to the user" do
          put :update, :id => @user.to_param, :user => valid_attributes
          response.should redirect_to(@user)
        end
      end
  
      describe "with invalid params" do
        it "assigns the user as @user" do
          # Trigger the behavior that occurs when invalid params are submitted
          User.any_instance.stub(:save).and_return(false)
          put :update, :id => @user.to_param, :user => {}
          assigns(:user).should eq(@user)
        end
  
        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          User.any_instance.stub(:save).and_return(false)
          put :update, :id => @user.to_param, :user => {}
          response.should render_template("edit")
        end
      end
    end
  end
  
  describe "follow pages" do

    describe "when not signed in" do

      it "should protect 'following'" do
        get :following, :id => 1
        response.should redirect_to(new_user_session_path)
      end

      it "should protect 'followers'" do
        get :followers, :id => 1
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "when signed in" do

      before(:each) do
        sign_in @user = Factory(:user)
        @other_user = Factory(:user, :email => Factory.next(:email))
        @user.follow!(@other_user)
      end

      it "should show user following" do
        get :following, :id => @user.to_param
        response.should have_selector("a", :href => user_path(@other_user),
                                           :content => @other_user.name)
      end

      it "should show user followers" do
        get :followers, :id => @other_user.to_param
        response.should have_selector("a", :href => user_path(@user),
                                           :content => @user.name)
      end
    end
  end

end