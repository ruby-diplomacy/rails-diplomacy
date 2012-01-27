class MessagesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :get_chatroom
  before_filter :user_must_belong_to_chatroom
  before_filter :get_power


  # GET /messages
  # GET /messages.json

  respond_to :js

  def index
    @messages = @chatroom.messages
  end

  def create
    @message = Message.new(params[:message])
    @message.power = @power
    @message.chatroom = @chatroom
    if @message.save
      flash[:notice] = 'Message was successfully created'
    respond_with @message
    end
  end 

  private 
  def get_chatroom
    @chatroom = Chatroom.find(params[:chatroom_id])
    raise ActionController::RoutingError.new("must supply a valid chatroom id!") if @chatroom.nil?
    @chatroom
  end

  def get_power
    @power = current_user.power_for_chatroom(@chatroom)
  end

  def authorized?
    @chatroom.powers.include? get_power
  end

  def user_must_belong_to_chatroom
    raise User::NotAuthorizedError unless authorized?
  end
end
