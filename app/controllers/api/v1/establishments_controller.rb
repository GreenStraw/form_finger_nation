module Api
  module V1
    class EstablishmentsController < BaseController
      before_filter :authenticate_user_from_token!, only: [:create, :update, :destroy]
      respond_to :json

      def index
        return render json: Establishment.all
      end

      def show
        return render json: Establishment.find(params[:id])
      end

      def create
        if current_user.has_role?(:admin)
          @establishment = Establishment.new(establishment_params)
          if @establishment.save
            return render json: @establishment
          else
            return render json: { :errors => 'Establishment not created' }, status: 422
          end
        else
          return render json: {}, status: 403
        end
      end

      def update
        if current_user.has_role?(:admin)
          @establishment = Establishment.find(params[:id])
          if params[:establishment][:user].nil?
            params[:establishment][:user] = @establishment.user_id
          end
          if @establishment.update!(establishment_params)
            return render json: @establishment
          else
            return render json: { :errors => 'Establishment not updated' }, status: 422
          end
        else
          return render json: {}, status: 403
        end
      end

      def destroy
        if current_user.has_role?(:admin)
          @establishment = Establishment.find(params[:id])
          if @establishment.destroy
            return render json: {}, status:200
          else
            return render json: { :errors => 'Establishment not deleted' }, status: 422
          end
        else
          return render json: {}, status: 403
        end
      end

      private

      def establishment_params
        params.require(:establishment).permit(:name, :image_url, :user_id, :address_id)
      end
    end
  end
end
