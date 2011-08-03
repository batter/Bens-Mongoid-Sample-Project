require 'spec_helper'

describe "pages/home.html.erb" do
  it "Displays a header for the page" do
    render
    assert_select "h1", :text => "Welcome to Ben's Sample App"
  end
end
