class Api::V1::SportsController < Api::V1::BaseController
  load_and_authorize_resource
  before_filter :authenticate_user_from_token!, only: [:create, :update, :destroy]

  def index
    respond_with @sports = Sport.all
  end

  def show
    respond_with @sport, :location=>api_v1_sports_path
  end

  def create
    @sport.save
    respond_with @sport, :location=>api_v1_sports_path
  end

  def update
    @sport.update(sport_params)
    respond_with @sport, :location=>api_v1_sports_path
  end

  def destroy
    @sport.destroy
    respond_with @sport, :location=>api_v1_sports_path
  end

  def subscribe_user
    @sport = Sport.find(params[:sport_id])
    @user = User.find(params[:fan_id])
    if !@sport.fans.include?(@user)
      @sport.fans << @user
    end
    respond_with @sport, :location=>api_v1_sports_path
  end

  def unsubscribe_user
    @sport = Sport.find(params[:sport_id])
    @user = User.find(params[:fan_id])
    if @sport.fans.include?(@user)
      @sport.fans.delete(@user)
    end
    respond_with @sport, :location=>api_v1_sports_path
  end

  private

  def subscribe_params
    params.permit(:fan_id)
  end

  def sport_params
    params.require(:sport).permit(:name, :image_url, {:fan_ids=>[],:team_ids=>[]})
  end

end
