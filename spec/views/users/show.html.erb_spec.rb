require 'spec_helper'

describe "users/show.html.erb" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :name => "Ben",
      :email => "ben@testbridge.com"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Ben/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/ben@testbridge.com/)
  end
end
