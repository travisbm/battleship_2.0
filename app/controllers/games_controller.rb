class GamesController < ApplicationController
  respond_to :js, :html

  def new
  end

  def create
    @game = Game.new

    if @game.save!
      redirect_to @game
    else
      render action: 'new'
    end
  end

  def show
    @game = Game.find(params[:id])
    cell = @game.get_cell(params[:row].to_i, params[:col].to_i)

    respond_to do |format|
      format.html
      format.json { render json: cell }
    end
  end

  def fire
    @game = Game.find(params[:id])

    @row = params[:row].to_i
    @col = params[:col].to_i

    @game.fire!(@row, @col)
    @cell = @game.get_cell(@row, @col)
  end
end
