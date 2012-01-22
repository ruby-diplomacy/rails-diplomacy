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
    @chatroom = chatrooms.find(params[:id])
  end

  # POST /chatrooms
  # POST /chatrooms.json
  def create
    @chatroom = Chatroom.new(params[:chatroom])
    @chatroom.save
  end


  private

  def chatrooms
    power = @user.power_for_game(@game)
    raise ActiveRecord::RecordNotFound if power.nil?
    Chatroom.power_game(power, @game)
  end

  def get_game
    raise ActionController::RoutingError.new("must supply a valid game id") if params[:game_id].nil?
   
    @game = Game.find(params[:game_id])
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
