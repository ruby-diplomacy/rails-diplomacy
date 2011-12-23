require 'spec_helper'

describe ChatroomPowerAssociation do
  let(:chatroom) {Factory.create :chatroom}
  let(:power) {chatroom.game.powers.first}
  
  it "should not have the same power twice" do
    expect{ChatroomPowerAssociation.create(:chatroom => chatroom, :power => power)}.to change{ChatroomPowerAssociation.count}.from(0).to(1)
    expect{ChatroomPowerAssociation.create(:chatroom => chatroom, :power => power)}.to raise_error(DataObjects::IntegrityError)
  end

  it "should not allow powers from other games" do
    game2 = Factory.create(:game)
    expect{ChatroomPowerAssociation.create(:chatroom => chatroom, :power => game2.powers.first)}.not_to change{ChatroomPowerAssociation.count}
  end
end
