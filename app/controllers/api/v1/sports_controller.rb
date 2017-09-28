class Api::V1::SportsController < Api::V1::BaseController
  load_and_authorize_resource :user
  load_and_authorize_resource :sport
  before_action :authenticate_user_from_token!, only: [:create, :update, :destroy]

  def index
    respond_with @sports
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
    if !@sport.fans.include?(@user)
      @sport.fans << @user
    end
    respond_with @sport
  end

  def unsubscribe_user
    if @sport.fans.include?(@user)
      @sport.fans.delete(@user)
    end
    respond_with @sport
  end

  private

  def sport_params
    params.require(:sport).permit(:name, :image_url, {:fan_ids=>[],:team_ids=>[]})
  end

end
