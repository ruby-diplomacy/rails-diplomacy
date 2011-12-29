require 'spec_helper'

describe "messages/show.html.erb" do
  before(:each) do
    @message = assign(:message, stub_model(Message))
  end

  it "renders attributes in <p>" do
    render
  end
end
