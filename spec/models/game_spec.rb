require 'spec_helper'

describe Game do
  subject {Factory.create :game}

  describe "User Assignment" do
    let(:user) {Factory.create :user}
    let(:power) {subject.powers.first}
    let(:chatroom) {Factory.create :chatroom, :game => subject}
    before do 
      subject.assign_user(user)
    end
 
    it "should have the user in the list" do
      subject.users.should include(user)
    end

    it "should NOT assign the same user twice" do
      expect {subject.assign_user(user)}.to_not change{UserAssignment.count}
    end

    it "should assing power to user" do
      expect{subject.assign_user(user, power)}.to_not change{UserAssignment.count}
      subject.power_for_user(user).should == power
    end

  end

end

