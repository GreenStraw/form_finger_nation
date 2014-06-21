class Api::V1::TeamsController < Api::V1::BaseController
  load_and_authorize_resource
  before_filter :authenticate_user_from_token!, only: [:create, :update, :destroy, :add_host, :remove_host]

  def index
    respond_with @teams = Team.all
  end

  def show
    respond_with @team
  end

  def create
    @team.save
    respond_with @team, :location=>api_v1_teams_path
  end

  def update
    @team.update(team_params)
    respond_with @team, :location=>api_v1_teams_path
  end

  def destroy
    @team.destroy
    respond_with @team, :location=>api_v1_teams_path
  end

  def subscribe_user
    @team = Team.find(params[:team_id])
    @user = User.find(params[:fan_id])
    if !@team.fans.include?(@user)
      @team.fans << @user
    end
    respond_with @team, :location=>api_v1_teams_path
  end

  def unsubscribe_user
    @team = Team.find(params[:team_id])
    @user = User.find(params[:fan_id])
    if @team.fans.include?(@user)
      @team.fans.delete(@user)
    end
    respond_with @team, :location=>api_v1_teams_path
  end

  def add_host
    @team = Team.find(params[:id])
    @user = User.find(params[:host_id])
    if !@team.hosts.include?(@user)
      @team.hosts << @user
    end
    respond_with @team, :location=>api_v1_teams_path
  end

  def remove_host
    @team = Team.find(params[:id])
    @user = User.find(params[:host_id])
    if @team.hosts.include?(@user)
      @team.hosts.delete(@user)
    end
    respond_with @team, :location=>api_v1_teams_path
  end

  private

  def subscribe_params
    params.permit(:fan_id)
  end

  def team_params
    params.require(:team).permit(:name, :information, :image_url, :sport_id, :address, {:fan_ids=>[], :hosts=>[]}, address_attributes: [:street1, :street2, :city, :state, :zip])
  end

end
