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
    if current_user == @user
      if !@team.fans.include?(@user)
        @team.fans << @user
      end
      return render json: @team
    else
      return render json: { :errors => @team.errors.full_messages }, status: 422
    end
  end

  def unsubscribe_user
    @team = Team.find(params[:team_id])
    @user = User.find(params[:fan_id])
    if current_user == @user
      if @team.fans.include?(@user)
        @team.fans.delete(@user)
      end
      return render json: @team
    else
      return render json: { :errors => @team.errors.full_messages }, status: 422
    end
  end

  def add_host
    @team = Team.find(params[:id])
    @user = User.find(params[:user_id])
    if current_user.has_role?(:team_admin, @team)
      if !@team.endorsed_hosts.include?(@user)
        @team.endorsed_hosts << @user
      end
      return render json: @team
    else
      return render json: {}, status: 403
    end
  end

  def remove_host
    @team = Team.find(params[:id])
    @user = User.find(params[:user_id])
    if current_user.has_role?(:team_admin, @team)
      if @team.endorsed_hosts.include?(@user)
        @team.endorsed_hosts.delete(@user)
      end
      return render json: @team
    else
      return render json: {}, status: 403
    end
  end

  private

  def subscribe_params
    params.permit(:fan_id)
  end

  def team_params
    params.require(:team).permit(:name, :information, :image_url, :sport_id, :address, {:fan_ids=>[]}, address_attributes: [:street1, :street2, :city, :state, :zip])
  end

end
