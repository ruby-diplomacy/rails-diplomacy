class StatesController < ApplicationController
  respond_to :json

  def show
    if params.has_key? :game_id
      @game = Game.find(params[:game_id])
      @state = @game.states.find_by_turn(params[:id])
    else
      @game = Game.find(params[:id])
      @state = @game.current_state
    end

    @state.state = Diplomacy::StateParser.new.parse_state @state.state

    respond_with(@state)
  end
end
