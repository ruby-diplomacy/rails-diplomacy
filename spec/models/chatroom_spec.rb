require 'spec_helper'

describe Chatroom do
  let(:game) {Factory.create(:game)}
  let(:user1) {Factory.create(:user)}
  let(:user2) {Factory.create(:user)}
  let(:power1) {game.powers.first}
  let(:power2) {game.powers.last}
  let(:chatroom) {Factory.create(:chatroom, :game => game )}

  before do
    game.assign_user(user1, power1)
    game.assign_user(user2, power2)
  end

  describe "instance methods" do 

    subject {chatroom}

    it "should add a power" do
      expect{subject.add_power(power1)}.to change{ChatroomPowerAssociation.count}.by(1)
    end

    it "should add a power array" do
      expect{subject.add_powers([power1, power2])}.to change{ChatroomPowerAssociation.count}.by(2)
    end

    describe "#user" do
      it "should return the chatroom users" do 
        subject.add_powers([power1, power2])
        subject.reload
        subject.users.count.should == 2
        subject.users.should include(user1)
        subject.users.should include(user2)
      end
    end
  end

  describe "scopes" do
    it "should return the chatrooms for a power" do
      chatroom.add_power(power1)
      Chatroom.power_game(game, power1).should eq([chatroom])
    end
  end
end
# == Schema Information
#
# Table name: chatrooms
#
#  id      :integer         not null, primary key
#  game_id :integer         not null
#

