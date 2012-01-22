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

    chatroom.add_power(power1)
  end

  describe "instance methods" do 

    subject {chatroom}
    describe "#user" do
      it "should return the chatroom users" do 
        subject.add_powers(game.powers)
        subject.users.count.should == 2
        subject.users.should include(user1)
        subject.users.should include(user2)
      end
    end

    it "should add a power" do
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
# == Schema Information
#
# Table name: chatrooms
#
#  id      :integer         not null, primary key
#  game_id :integer         not null
#

