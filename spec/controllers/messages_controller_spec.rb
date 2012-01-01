require 'spec_helper'


describe MessagesController do
  let!(:game) {Factory.create(:game)}
  let!(:chatroom) {Factory.create(:chatroom, :game => game)}
  let!(:user) {Factory.create(:user)}
  let!(:malicious){Factory.create :user}
  let!(:power) {game.powers.first}
  let!(:message) {Factory.create(:message, :power => power, :chatroom => chatroom, :text => 'Hello there!')}
  let(:valid_attributes) {{:power => power, :text => 'some text'}}

  before {
    game.assign_user(user, power)
    chatroom.powers << game.powers.first
    chatroom.save
  }



  describe "GET index" do
    it_behaves_like "chat controller action"

    it "assigns all messages as @messages" do
      get :index, :chatroom_id => chatroom.id
      assigns(:messages).should eq([message])
    end
  end

  describe "POST create", :focus => true do
    it_behaves_like "chat controller action"
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
