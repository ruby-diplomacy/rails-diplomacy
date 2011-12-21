class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.json
  respond_to :js, :json

  def index
    debugger
    @user = logged_user
    chatroom_id = params[:chatroom]
    limit = params[:limit] 
  end

  def create
    debugger
    @user = logged_user
    @message = Message.new(params[:message])
    @message.power = @user.power_for_game(@message.game)
    if @message.save
      flash[:notice] = 'Message was successfully created'
    end
    respond_with @message
  end
end
