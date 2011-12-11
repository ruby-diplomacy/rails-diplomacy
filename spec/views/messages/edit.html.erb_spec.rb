require 'spec_helper'

describe "messages/edit.html.erb" do
  before(:each) do
    @message = assign(:message, stub_model(Message))
  end

  it "renders the edit message form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => messages_path(@message), :method => "post" do
    end
  end
end
