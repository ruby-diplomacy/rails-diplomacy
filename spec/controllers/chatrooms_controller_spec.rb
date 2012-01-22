require 'spec_helper'


describe ChatroomsController do
  let!(:game) {Factory.create(:game)}
  let!(:chatroom) {Factory.create(:chatroom, :game => game)}
  let!(:user) {Factory.create(:user)}
  let!(:power) {game.powers.first} 
  let(:malicious){Factory.create :user}
  let!(:message) {Factory.create(:message, :power => power, :chatroom => chatroom, :text => 'Hello there!')}
  let(:prefix) {'game_'}

  before {
    game.assign_user(user, power)
    chatroom.powers << game.powers.first
    chatroom.save
  }


  describe "GET index" do 

    it "should return 401 Unauthorized if the user is not in the given game" do
      controller.should_receive(:logged_user).and_return(malicious)
      get :index, :game_id => game.id, :name_prefix => prefix
      response.status.should == 401
    end

    it "should return 404 without game_id" do
      expect{get :index, :name_prefix => prefix}.to raise_error(ActionController::RoutingError)
    end

    it "assigns all user chatrooms as @chatrooms" do
      get :index, :game_id => chatroom.id, :name_prefix => prefix
      assigns(:chatrooms).should eq([chatroom])
    end
  end

  describe "POST create" do

    it "should return 401 Unauthorized if the user is not in the given game" do
      controller.should_receive(:logged_user).and_return(malicious)
      post :create, :game_id => game.id, :name_prefix => prefix
      response.status.should == 401
    end

    it "should return 404 without game_id" do
      expect{post :create, :name_prefix => prefix}.to raise_error(ActionController::RoutingError)
    end

    subject{post :create, :game_id => game.id, :chatroom => {:game_id => game.id}, :name_prefix => prefix}

    it "creates a new Message" do
      expect{subject}.to change{Chatroom.count}.by(1)
    end

    it "assigns a newly created message as @chatrrom" do
      subject
      assigns(:chatroom).should be_a(Chatroom)
      assigns(:chatroom).should be_persisted
    end
  end

  describe "GET show" do
    it "should return 401 Unauthorized if the user is not in the given game" do
      controller.should_receive(:logged_user).and_return(malicious)
      get :show, :game_id => game.id,  :name_prefix => prefix, :id => chatroom.id
      response.status.should == 401
    end 
 
    it "should return 404 if the user is not in the given chatroom" do
      controller.should_receive(:logged_user).and_return(malicious)
      game.assign_user(malicious, game.powers.last)
      get :show, :game_id => game.id,  :name_prefix => prefix, :id => chatroom.id
      response.status.should == 404
    end

    it "should return 404 without chatroom_id", :focus => true do
      get :show, :game_id => game.id, :name_prefix => prefix
      response.status.should == 404
    end

    it 'get the requested chatroom' do
      get :show, :game_id => game.id,  :name_prefix => prefix, :id => chatroom.id
      assigns(:chatroom).should == chatroom
    end
  end
end

