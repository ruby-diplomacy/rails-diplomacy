class StatesController < ApplicationController
  respond_to :json

  def show
    @game = Game.find(params[:game_id])
    @state = @game.states.find_by_turn(params[:id])

    @state.state = Diplomacy::StateParser.new.parse_state @state.state

    respond_with(@state)
  end
end
