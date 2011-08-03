require 'spec_helper'

describe "pages/about.html.erb" do
  it "Displays a header for the page" do
    render
    assert_select "h1", :text => "About"
  end
end
