require 'spec_helper'

describe "messages/index.html.erb" do
  before(:each) do
    assign(:messages, [
      stub_model(Message),
      stub_model(Message)
    ])
  end

  it "renders a list of messages" do
    render
  end
end
