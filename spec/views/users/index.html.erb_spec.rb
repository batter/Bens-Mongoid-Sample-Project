require 'spec_helper'

describe "users/index.html.erb" do
  before(:each) do
    assign(:users, [
      stub_model(User,
        :name => "Ben",
        :email => "ben@testbridge.com"
      ),
      stub_model(User,
        :name => "Ben",
        :email => "ben@testbridge.com"
      )
    ])
  end

  it "renders a list of users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Ben".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "ben@testbridge.com".to_s, :count => 2
  end
end
