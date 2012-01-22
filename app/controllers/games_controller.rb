class GamesController < ApplicationController

  def index
    @games = Game.all
    respond_to do |format|
      format.html
      format.json {render json: @games}
    end
  end

  def show
    @game = Game.find(params[:id])
    respond_to do |format|
      format.html
      format.json {render json: @game}
    end
  end

  def new
    @game = Game.new
    respond_to do |format|
      format.html
      format.json {render json: @game}
    end
  end

  def create
    @game = Game.new(params[:game])

    respond_to do |format|
      if @game.save
        format.html {redirect_to @game, notice: 'Game was successfully created.'}
        format.json {render json: @game, status: created, location: @game }
      else
        format.html {render action: "new"}
        format.json {render json: @game.errors, status: :unprocessable_entity }
      end

    end

    def update
      @game = Game.first(params[:id])

      respond_to do |format|
        if @game.update_attributes(params[:user])
          format.html { redirect_to @game, notice: 'User was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @game.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /users/1
    # DELETE /users/1.json
    def destroy
      @game = Game.first(params[:id])
      @game.destroy

      respond_to do |format|
        format.html { redirect_to games_url }
        format.json { head :ok }
      end
    end
  end

  def edit
    @game = Game.first(params[:id])
  end

end
