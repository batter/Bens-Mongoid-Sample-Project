require 'spec_helper'

describe MicropostsController do
  render_views
  
  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(new_user_session_path)
    end
  end
  
  describe "POST 'create'" do

    before(:each) do
      @user = sign_in Factory(:user)
    end

    describe "failure" do

      before(:each) do
        @attr = { :content => "" }
      end

      it "should not create a micropost" do
        expect { post :create, :micropost => @attr }.not_to change{Micropost.count}
      end

      it "should render the home page" do
        post :create, :micropost => @attr
        response.should render_template('pages/home')
        response.should have_selector("div#error_explanation")
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :content => "Lorem ipsum" }
      end

      it "should create a micropost" do
        expect {
          post :create, :micropost => @attr
        }.to change(Micropost, :count).by(1)
      end

      it "should redirect to the home page" do
        post :create, :micropost => @attr
        response.should redirect_to(root_path)
      end

      it "should have a flash message" do
        post :create, :micropost => @attr
        flash[:success].should =~ /micropost created/i
      end
    end
  end
  
   describe "DELETE 'destroy'" do

    describe "for an unauthorized user" do

      before(:each) do
        @user = Factory(:user)
        wrong_user = Factory(:user, :email => Factory.next(:email))
        sign_in wrong_user
        @micropost = Factory(:micropost, :user => @user)
      end

      it "should deny access" do
        delete :destroy, :id => @micropost.to_param
        response.should redirect_to(root_path)
      end
    end

    describe "for an authorized user" do

      before(:each) do
        sign_in @user = Factory(:user)
        @micropost = Factory(:micropost, :user => @user)
      end

      it "should destroy the micropost" do
        expect {
          delete :destroy, :id => @micropost.to_param
        }.to change(Micropost, :count).by(-1)
      end
    end
  end
end
