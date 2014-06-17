class Api::V1::TeamsController < Api::V1::BaseController
  before_filter :authenticate_user_from_token!, only: [:create, :update, :destroy, :add_host, :remove_host]

  def index
    return render json: Team.all
  end

  def show
    return render json: Team.find(params[:id])
  end

  def create
    if current_user.has_role?(:admin)
      @team = Team.new(team_params)
      if @team.save
        return render json: @team
      else
        return render json: { :errors => @team.errors.full_messages }, status: 422
      end
    else
      return render json: {}, status: 403
    end
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

  def update
    @team = Team.find(params[:id])
    if current_user.has_role?(:admin) || current_user.has_role?(:team_admin, @team)
      if @team.update!(team_params)
        return render json: @team
      else
        return render json: { :errors => @team.errors.full_messages }, status: 422
      end
    else
      return render json: {}, status: 403
    end
  end

  def destroy
    if current_user.has_role?(:admin)
      @team = Team.find(params[:id])
      if @team.destroy
        return render json: {}, status:200
      else
        return render json: { :errors => @team.errors.full_messages }, status: 422
      end
    else
      return render json: {}, status: 403
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
    params.require(:team).permit(:name, :information, :image_url, :sport_id, :address, {:fan_ids=>[]})
  end

end
