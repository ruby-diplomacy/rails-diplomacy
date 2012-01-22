require 'spec_helper'

describe Message do
  let(:game) {Factory.create(:game)}
  let(:chatroom) {Factory.create(:chatroom, :game => game, :powers => game.powers)}
  subject {Factory.create(:message, :power => game.powers.first, :chatroom => chatroom)}

  describe "#game" do
    it "should return the message game" do
      subject.game.should == game
    end
  end
end
# == Schema Information
#
# Table name: messages
#
#  id          :integer         not null, primary key
#  text        :string(50)
#  power_id    :integer
#  chatroom_id :integer
#

