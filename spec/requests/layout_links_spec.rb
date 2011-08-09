require 'spec_helper'

describe "LayoutLinks" do
  
  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end

  it "should have an About page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => "About")
  end

  it "should have a Help page at '/help'" do
    get '/help'
    response.should have_selector('title', :content => "Help")
  end
  
  describe "the header" do
    it "should have a link to 'Home'" do
      visit about_path
      response.should have_selector('header a', :href => root_path, :content => "Home")
      
      within 'header' do |scope| 
        scope.click_link "Home"
        response.should have_selector('title', :content => 'Home')
      end
    end
    
    it "should have a link to 'Help'" do
      visit root_path
      response.should have_selector('header a', :href => help_path, :content => "Help")
      click_link "Help"
      response.should have_selector('title', :content => 'Help')
    end
  end
  
  describe "the footer" do
    it "should have a link to 'Home'" do
      visit about_path
      response.should have_selector('footer a', :href => root_path, :content => "Home")
      within 'footer' do |scope| 
        scope.click_link "Home"
        response.should have_selector('title', :content => 'Home')
      end
    end
    
    it "should have a link to 'About'" do
      visit root_path
      response.should have_selector('footer a', :href => about_path, :content => "About")
      click_link "About"
      response.should have_selector('title', :content => 'About')
    end
  end
  
  describe "when not signed in, the header" do
    it "should have a link to 'Sign in'" do
      visit root_path
      response.should have_selector('header a', :href => new_user_session_path, :content => "Sign in")
      click_link "Sign in"
      response.should have_selector('title', :content => 'Sign in')
    end
  end
  
  describe "when signed in, the header" do
    before(:each) do
      @user = Factory(:user)
      integration_sign_in @user
    end
    
     it "should have a link to 'Settings' (profile)" do
      visit root_path
      response.should have_selector('header a', :href => edit_user_registration_path, :content => "Settings")
      click_link "Settings"
      response.should have_selector('title', :content => 'Profile Settings')
    end
    
    it "should have a link to 'Users' (list)" do
      visit root_path
      response.should have_selector('header a', :href => users_path, :content => "Users")
      click_link "Users"
      response.should have_selector('title', :content => 'User List')
    end
    
    it "should have a signout link" do
      visit root_path
      response.should have_selector('header a', :href => destroy_user_session_path, :content => "Sign out")
      delete destroy_user_session_path
      response.should redirect_to(root_path)
      flash[:notice].should =~ /Signed out successfully./
    end
  end
  
end