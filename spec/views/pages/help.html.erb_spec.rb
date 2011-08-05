require 'spec_helper'

describe "pages/help.html.erb" do
  it "Displays a header for the page" do
    render
    assert_select "h1", :text => "Help"
  end
end
