class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.json
  respond_to :js, :json
  def create
    @user = logged_user
    @message = Message.new(params[:message])
    @message.power = @user.power_for_chatroom(@message.chatroom)

    if @message.save
      flash[:notice] = 'Message was successfully created'
    end
    respond_with @message
  end
end
