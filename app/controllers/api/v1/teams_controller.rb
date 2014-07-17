class Api::V1::TeamsController < Api::V1::BaseController
  load_and_authorize_resource :user
  load_and_authorize_resource :team
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

  def add_host
    if !@team.hosts.include?(@user)
      @team.hosts << @user
    end
    respond_with @team, :location=>api_v1_teams_path
  end

  def remove_host
    if @team.hosts.include?(@user)
      @team.hosts.delete(@user)
    end
    respond_with @team, :location=>api_v1_teams_path
  end

  def add_admin
    @user.add_role(:team_admin, @team)
    respond_with @team, :location=>api_v1_teams_path
  end

  def remove_admin
    @user.remove_role(:team_admin, @team)
    respond_with @team, :location=>api_v1_teams_path
  end

  private

  def subscribe_params
    params.permit(:fan_id)
  end

  def team_params
    params.require(:team).permit(:name, :information, :image_url, :sport_id, :address, {:fan_ids=>[], :host_ids=>[]}, address_attributes: [:street1, :street2, :city, :state, :zip])
  end

end
