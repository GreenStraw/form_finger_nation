module Api
  module V1
    class SportsController < BaseController
      before_filter :authenticate_user_from_token!, only: [:create, :update, :destroy]
      respond_to :json

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
            return render json: { :errors => 'Sport not created' }, status: 422
          end
        else
          return render json: {}, status: 403
        end
      end

      def update
        if current_user.has_role?(:admin)
          @sport = Sport.find(params[:id])
          if @sport.update!(sport_params)
            return render json: @sport
          else
            return render json: { :errors => 'Sport not updated' }, status: 422
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
            return render json: { :errors => 'Sport not deleted' }, status: 422
          end
        else
          return render json: {}, status: 403
        end
      end

      private

      def sport_params
        params.require(:sport).permit(:name, :image_url, {:users=>[],:teams=>[]})
      end
    end
  end
end
