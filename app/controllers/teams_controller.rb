class TeamsController < ApplicationController
  respond_to :html, :js
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :team
  load_and_authorize_resource :user
  load_and_authorize_resource :sport

  # GET /teams
  def index
    @has_favorites = user_signed_in? && current_user.followed_teams.any?
    respond_with @teams.order(:sport_id => :desc)
  end

  # GET /teams/1
  def show
    @map_markers = Gmaps4rails.build_markers(@team) do |team, marker|
      marker.lat team.address.latitude
      marker.lng team.address.longitude
    end
    respond_with @team
  end

  # GET /teams/new
  def new
    @team.sport = @sport
    respond_with @team
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
  end

  # POST /teams
  def create
    flash[:notice] = 'Team was successfully created.' if @team.save
    respond_with @team, location: team_path(@team)
  end

  # PATCH/PUT /teams/1
  def update
    flash[:notice] = 'Team was successfully updated.' if @team.update(team_params)
    respond_with @team, location: team_path(@team)
  end

  # DELETE /teams/1
  def destroy
    @team.destroy
    redirect_to teams_url, notice: 'Team was successfully destroyed.'
  end

  def subscribe
    if !@team.fans.include?(current_user)
      @team.fans << current_user
    end
    flash.now[:notice] = "#{@team.name} added to favotites"
    respond_to do |format|
      format.js { render action: 'subscribe' }
    end
  end

  def unsubscribe
    if @team.fans.include?(current_user)
      @team.fans.delete(current_user)
    end
    flash.now[:notice] = "#{@team.name} removed from favotites"
    respond_to do |format|
      format.js { render action: 'subscribe' }
    end
  end

  def add_host
    if !@team.hosts.include?(@user)
      @team.hosts << @user
    end
    respond_to do |format|
      format.js { render action: 'host' }
    end
  end

  def remove_host
    if @team.hosts.include?(@user)
      @team.hosts.delete(@user)
    end
    respond_to do |format|
      format.js { render action: 'host' }
    end
  end

  def add_admin
    if !@user.has_role?(:team_admin, @team)
      @user.add_role(:team_admin, @team)
    end
    respond_to do |format|
      format.js { render action: 'admin' }
    end
  end

  def remove_admin
    if @user.has_role?(:team_admin, @team)
      @user.remove_role(:team_admin, @team)
    end
    respond_to do |format|
      format.js { render action: 'admin' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def team_params
    params.require(:team).permit(:name, :information, :text, :image_url, :sport_id, :references, :twitter_name, :twitter_widget_id, :address, [address_attributes: [:street1, :street2, :city, :state, :zip]])
  end
end
