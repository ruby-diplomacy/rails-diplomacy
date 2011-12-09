require 'spec_helper'
describe GameUser do
  describe "scopes" do
    let!(:unassigned) {FactoryGirl.create_list(:game_user_assoc, 2)}
    let!(:assigned) {FactoryGirl.create_list(:game_user_assoc_with_power, 2)}

    it "should return the assigned powers" do
      GameUser.with_power.should eq assigned
    end
    it "should return the unassigned powers" do
      GameUser.without_power.should eq unassigned
    end

  end
end
