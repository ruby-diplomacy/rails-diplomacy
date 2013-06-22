class StatesController < ApplicationController
  respond_to :json

  def show
    @game = Game.find(params[:id])
    @state = @game.current_state

    respond_with(@state)
  end
end
