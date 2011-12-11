require 'spec_helper'

describe "chatrooms/show.html.erb" do
  before(:each) do
    @chatroom = assign(:chatroom, stub_model(Chatroom))
  end

  it "renders attributes in <p>" do
    render
  end
end
