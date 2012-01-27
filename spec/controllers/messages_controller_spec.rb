require 'spec_helper'


describe MessagesController do
  let!(:game) {Factory.create(:game)}
  let!(:chatroom) {Factory.create(:chatroom, :game => game)}
  let!(:user) {Factory.create(:user)}
  let!(:power) {game.powers.first} 
  let(:malicious){Factory.create :user}
  let!(:message) {Factory.create(:message, :power => power, :chatroom => chatroom, :text => 'Hello there!')}
  let(:prefix) {'chatroom_'}

  before {
    sign_in user
    game.assign_user(user, power)
    chatroom.add_power(power)
    chatroom.save
  }


  describe "GET index" do
    it "should return 404 without chatroom_id" do
      get :index
      response.status.should == 404
    end

    it "assigns all messages as @messages" do
      get :index, :chatroom_id => chatroom.id, :name_prefix => prefix
      assigns(:messages).should eq([message])
    end
  end

  describe "POST create" do

    subject{post :create, :chatroom_id => chatroom.id, :message => {:text => 'new message'}, :format => 'js', :name_prefix => prefix}

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
