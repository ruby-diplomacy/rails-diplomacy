require 'spec_helper'


describe User do
  let(:game) {Factory.create :game}
  subject {Factory.create :user}

  describe "#power_for_chatroom" do
    let(:chatroom) {Factory.create :chatroom, :game => game, :powers => [game.powers.first, game.powers.last]}
    let(:power) {game.powers.first}
    before {game.assign_user(subject, power)}

    it "should return the assigned power for the user" do
      subject.power_for_chatroom(chatroom).should == power
    end
  end
  
end