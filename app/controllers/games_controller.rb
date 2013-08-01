class GamesController < ApplicationController
  # GET /games
  # GET /games.json
  def index
    if params.has_key? :scope
      @games = Game.send(params[:scope])
    else
      @games = Game.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])
    @sc_list_per_power = @game.current_state.sc_list_per_power.with_indifferent_access#.sort_by {|_k, v| v.length }.reverse
    @power_assignments = @game.power_assignments.sort do |pa1, pa2|
      if @sc_list_per_power.has_key? pa1.power and @sc_list_per_power.has_key? pa2.power
        @sc_list_per_power[pa1.power].length <=> @sc_list_per_power[pa2.power].length
      else
        0
      end
    end

    if user_signed_in? and joined?(current_user, @game)
      @order_list = OrderList.where(power: power_for_user(current_user, @game).power, state_id: @game.current_state.id).first_or_initialize
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = Game.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(params[:game])

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end
  
  def start
    @game = Game.find(params[:id])

    if @game.phase == Game::PHASES[:awaiting_players]
      respond_to do |format|
        if @game.progress_phase!
          format.html { redirect_to @game, notice: 'Game started.' }
          format.json { head :no_content }
        else
          format.html { redirect_to @game, error: 'Game could not be started.' }
          format.json { render json: @game.errors, status: :unprocessable_entity }
        end
      end
    else
      format.html { redirect_to @game, error: 'Game has already begun.' }
      format.json { render json: { game: 'Game has already begun' }, status: :unprocessable_entity }
    end
  end

  private

  def power_for_user(user, game)
    user.power_assignments.where(game_id: game.id).first
  end
  helper_method :power_for_user

  def joined?(user, game)
    not power_for_user(user, game).nil?
  end
  helper_method :joined?

end
