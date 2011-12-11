require 'spec_helper'

describe "chatrooms/index.html.erb" do
  before(:each) do
    assign(:chatrooms, [
      stub_model(Chatroom),
      stub_model(Chatroom)
    ])
  end

  it "renders a list of chatrooms" do
    render
  end
end
