class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.json
  before_filter :require_login
  before_filter :get_chatroom
  before_filter :user_must_belong_to_chatroom
  before_filter :get_power

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
    @chatroom = Chatroom.get(params[:chatroom_id])
  end

  def get_power
    @power = @user.power_for_chatroom(@chatroom)
  end

  def authorized?
    @power = @user.power_for_chatroom(@chatroom)
    @chatroom.powers.include? @power
  end

  def user_must_belong_to_chatroom
    raise User::NotAuthorizedError unless authorized?
  end
end
