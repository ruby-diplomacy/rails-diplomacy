class MessagesController < ChatController 
  
  before_filter :require_login
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
end
