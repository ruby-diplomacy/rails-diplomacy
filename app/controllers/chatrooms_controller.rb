class ChatroomsController < ApplicationController
  before_filter :require_login
  before_filter :get_game
  before_filter :user_must_belong_to_game

  # GET /chatrooms
  # GET /chatrooms.json
  #
  respond_to :html
  def index
    @chatrooms = chatrooms
  end

  # GET /chatrooms/1
  # GET /chatrooms/1.json
  def show
    @chatroom = chatrooms.get!(params[:id])
  end

  # POST /chatrooms
  # POST /chatrooms.json
  def create
    @chatroom = Chatroom.new(params[:chatroom])
    @chatroom.save
  end


  private

  def chatrooms 
    Chatroom.game_user(@game, @user)
  end

  def get_game
    @game = Game.get(params[:game_id])
    raise ActionController::RoutingError.new("must supply a valid game id") if @game.nil?
    @game
  end

  def get_power
    @power = @game.power_for_user @user
  end

  def authorized?
    @game.users.include? @user
  end

  def user_must_belong_to_game
    raise User::NotAuthorizedError unless authorized? 
  end

end
