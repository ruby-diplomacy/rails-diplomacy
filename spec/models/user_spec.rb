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

    it "should return nil if the user is not in the game" do
      chatroom  = Factory.build :chatroom
      subject.power_for_chatroom(chatroom).should be_nil
    end
  end
  
end
# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  username               :string(50)      not null
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#

