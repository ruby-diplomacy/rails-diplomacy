require 'spec_helper'

describe "chatrooms/edit.html.erb" do
  before(:each) do
    @chatroom = assign(:chatroom, stub_model(Chatroom))
  end

  it "renders the edit chatroom form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => chatrooms_path(@chatroom), :method => "post" do
    end
  end
end
