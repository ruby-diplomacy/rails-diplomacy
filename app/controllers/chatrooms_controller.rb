class ChatroomsController < ChatController
  before_filter :require_login


  # GET /chatrooms
  # GET /chatrooms.json
  #
  respond_to :html
  def index
    @chatrooms = Chatroom.all
  end

  # GET /chatrooms/1
  # GET /chatrooms/1.json
  def show
    @chatroom = Chatroom.get(params[:id])
    user_must_belong_to_chatroom
  end

  # GET /chatrooms/new
  # GET /chatrooms/new.json
  def new
    @chatroom = Chatroom.new
  end

  # GET /chatrooms/1/edit
  def edit
    @chatroom = Chatroom.get(params[:id])
  end

  # POST /chatrooms
  # POST /chatrooms.json
  def create
    @chatroom = Chatroom.new(params[:chatroom])

    respond_to do |format|
      if @chatroom.save
        format.html { redirect_to @chatroom, notice: 'Chatroom was successfully created.' }
        format.json { render json: @chatroom, status: :created, location: @chatroom }
      else
        format.html { render action: "new" }
        format.json { render json: @chatroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /chatrooms/1
  # PUT /chatrooms/1.json
  def update
    @chatroom = Chatroom.get(params[:id])

    respond_to do |format|
      if @chatroom.update_attributes(params[:chatroom])
        format.html { redirect_to @chatroom, notice: 'Chatroom was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @chatroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chatrooms/1
  # DELETE /chatrooms/1.json
  def destroy
    @chatroom = Chatroom.first(params[:id])
    @chatroom.destroy

    respond_to do |format|
      format.html { redirect_to chatrooms_url }
      format.json { head :ok }
    end
  end
end
