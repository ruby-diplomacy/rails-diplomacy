require 'spec_helper'


describe MessagesController do
  include_context "chat controller"
  let!(:message) {Factory.create(:message, :power => power, :chatroom => chatroom, :text => 'Hello there!')}



  describe "GET index" do
    it_behaves_like "chat controller action"

    it "should return 404 without chatroom_id" do
      expect{get :index}.to raise_error(ActionController::RoutingError)
    end
    it "assigns all messages as @messages" do
      get :index, :chatroom_id => chatroom.id
      assigns(:messages).should eq([message])
    end
  end

  describe "POST create", :focus => true do
    it_behaves_like "chat controller action" 

    it "should return 404 without chatroom_id" do
      expect{get :index}.to raise_error(ActionController::RoutingError)
    end
    subject{post :create, :chatroom_id => chatroom.id, :message => {:text => 'new message'}, :format => 'js'}
    it "creates a new Message" do
      expect{subject}.to change{Message.count}.by(1)
    end

    it "assigns a newly created message as @message" do
      subject
      assigns(:message).should be_a(Message)
      assigns(:message).should be_persisted
    end
  end
end
