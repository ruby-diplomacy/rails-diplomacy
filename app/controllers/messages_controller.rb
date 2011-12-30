class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.json
  before_filter :require_login
  before_filter :get_chatroom
  before_filter :user_must_belong_to_chatroom
  before_filter :get_power

  def index
    @messages = @chatroom.messages
  end

  def create
    @user = logged_user
    @message = Message.new(params[:message])
    @message.power = @user.power_for_game(@message.game)
    if @message.save
      flash[:notice] = 'Message was successfully created'
    end
    respond_with @message
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
