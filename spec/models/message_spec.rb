require 'spec_helper'

describe Message do
  let(:game) {Factory.create(:game)}
  let(:chatroom) {Factory.create(:chatroom, :game => game)}
  subject {Factory.create(:message, :chatroom => chatroom)}

  describe "#game" do
    it "should return the message game" do
      subject.game.should == game
    end
  end
end
