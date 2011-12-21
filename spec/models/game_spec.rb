require 'spec_helper'

describe Game do
  subject {Factory.create :game}

  describe "User Assignment" do
    let(:user) {Factory.create :user}
    let(:power) {subject.powers.first}
    before {subject.users << user; subject.save}
 
    it "should have the user in the list" do
      subject.users.should include(user)
    end

    it "should NOT assign the same user twice" do
      subject.users << user
      subject.save
      subject.reload
      subject.users.to_a.count(user).should == 1
    end

    it "should assing power to user" do
      subject.assign_user(user, power)
      subject.power_for_user(user).should == power
    end
  end

end

