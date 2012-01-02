require 'spec_helper'

describe GamesController do
  let!(:games) {FactoryGirl.create_list(:game, 4)}

  describe "GET 'index" do
    it "should assign @games and return http success" do
      get 'index'
      assigns(:games).should eq(games)
      response.should be_success
    end
  end

  describe "GET show" do
    context "when given a game id" do
      it "should return the game" do
        get "show", :id => games.first.id
        assigns(:game).should eq(games.first)
      end
    end

    context "when given an invalid game id" do
      it "should return 404" do
        get :show, :id => Game.last.id + 40
        response.status.should == 404
      end
    end
  end
end
