class SportsController < ApplicationController
  before_action :set_sport, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  respond_to :html, :js

  # GET /sports
  def index
    respond_with @sports
  end

  # GET /sports/1
  def show
    respond_with @sport
  end

  # GET /sports/new
  def new
    respond_with @sport
  end

  # GET /sports/1/edit
  def edit
    respond_with @sport
  end

  # POST /sports
  def create
    if @sport.save
      flash[:notice] = 'Sport was successfully created.'
      respond_with @sport, location: sport_path(@sport)
    else
      respond_with @sport, location: new_sport_path
    end
  end

  # PATCH/PUT /sports/1
  def update
    if @sport.update(sport_params)
      flash[:notice] = 'Sport was successfully updated.'
      respond_with @sport, location: sport_path(@sport)
    else
      respond_with @sport, location: edit_sport_path(@sport)
    end
  end

  # DELETE /sports/1
  def destroy
    @sport.destroy
    redirect_to sports_url, notice: 'Sport was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sport
      @sport = Sport.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sport_params
      params.require(:sport).permit(:name, :image_url)
    end
end
