require 'spec_helper'

describe Game do
  let(:game) { FactoryGirl.create(:game) }

  it "should have a valid factory" do
    game.should be_valid
  end

  it "should begin at the 'awaiting players' phase" do
    game.phase.should eq(Game::PHASES[:awaiting_players])
  end

  it "should have a valid initial state" do
    state = game.current_state
    state.turn.should eq(1)
    state.game = game

    # This test is meaningful only as long as we don't have
    # variant maps etc
    state.year.should eq(1901)
    state.season.should eq("Spring")
  end

  it "should destroy dependents when destroyed" do
    FactoryGirl.create(:power_assignment, game: game)

    PowerAssignment.count.should eq(1)
    State.count.should eq(1)
    
    game.destroy

    PowerAssignment.count.should eq(0)
    State.count.should eq(0)
  end

  describe "current_state" do
    it "should return the state with the highest turn number" do
      # first turn already created by calling let(:game)
      current_state = FactoryGirl.create(:state, game: game, turn: 2)
      
      game.current_state.id.should eq(current_state.id)
    end
  end

  describe "progress_phase!" do
    context "when awaiting players" do
      it "should go to movement" do
        game.phase = Game::PHASES[:awaiting_players]
        game.progress_phase!
        game.phase.should eq(Game::PHASES[:movement])
      end
    end
    context "when in movement, with retreats present" do
      it "should go to retreats"
    end
    context "when in movement, without retreats present" do
      context "if it is Fall" do
        it "should go to supply"
      end
      context "if it is Spring" do
        it "should go to movement"
      end
    end
  end
end
