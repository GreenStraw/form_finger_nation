class Api::V1::SportsController < Api::V1::BaseController
  before_filter :authenticate_user_from_token!, only: [:create, :update, :destroy]

  def index
    return render json: Sport.all
  end

  def show
    return render json: Sport.find(params[:id])
  end

  def create
    if current_user.has_role?(:admin)
      @sport = Sport.new(sport_params)
      if @sport.save
        return render json: @sport
      else
        return render json: { :errors => @sport.errors.full_messages }, status: 422
      end
    else
      return render json: {}, status: 403
    end
  end

  def subscribe_user
    @sport = Sport.find(params[:sport_id])
    @user = User.find(params[:fan_id])
    if current_user == @user
      if !@sport.fans.include?(@user)
        @sport.fans << @user
      end
      return render json: @sport
    else
      return render json: { :errors => @sport.errors.full_messages }, status: 422
    end
  end

  def unsubscribe_user
    @sport = Sport.find(params[:sport_id])
    @user = User.find(params[:fan_id])
    if current_user == @user
      if @sport.fans.include?(@user)
        @sport.fans.delete(@user)
      end
      return render json: @sport
    else
      return render json: { :errors => @sport.errors.full_messages }, status: 422
    end
  end

  def update
    if current_user.has_role?(:admin)
      @sport = Sport.find(params[:id])
      if @sport.update!(sport_params)
        return render json: @sport
      else
        return render json: { :errors => @sport.errors.full_messages }, status: 422
      end
    else
      return render json: {}, status: 403
    end
  end

  def destroy
    if current_user.has_role?(:admin)
      @sport = Sport.find(params[:id])
      if @sport.destroy
        return render json: {}, status:200
      else
        return render json: { :errors => @sport.errors.full_messages }, status: 422
      end
    else
      return render json: {}, status: 403
    end
  end

  private

  def subscribe_params
    params.permit(:fan_id)
  end

  def sport_params
    params.require(:sport).permit(:name, :image_url, {:fan_ids=>[],:team_ids=>[]})
  end

end
