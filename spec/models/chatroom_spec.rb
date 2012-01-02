require 'spec_helper'

describe Chatroom do
  let(:game) {Factory.create(:game)}
  let(:user1) {Factory.create(:user)}
  let(:user2) {Factory.create(:user)}
  let(:power1) {game.powers.first}
  let(:power2) {game.powers.last}
  let(:chatroom) {Factory.create(:chatroom, :game => game, :powers => [power1, power2] )}

  before do
    game.assign_user(user1, power1)
    game.assign_user(user2, power2)
  end

  describe "instance methods" do 

    subject {chatroom}
    describe "#user" do
      it "should return the chatroom users" do 
        subject.users.count.should == 2
        subject.users.should include(user1)
        subject.users.should include(user1)
      end
    end
  end

  describe "class methods" do 
    describe "#all_for_game_user" do
      it "should return the chatroom for the user" do 
        Chatroom.game_user(game, user1).should == [chatroom]
      end
    end

  end
end
