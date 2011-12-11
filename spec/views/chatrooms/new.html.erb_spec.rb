require 'spec_helper'

describe "chatrooms/new.html.erb" do
  before(:each) do
    assign(:chatroom, stub_model(Chatroom).as_new_record)
  end

  it "renders new chatroom form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => chatrooms_path, :method => "post" do
    end
  end
end
