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
        if current_user.has_any_role?(:admin, :establishment_manager)
          @establishment = Establishment.new(establishment_params)
          if @establishment.save
            current_user.add_role(:manager, @establishment)
            return render json: @establishment
          else
            return render json: { :errors => 'Establishment not created' }, status: 422
          end
        else
          return render json: {}, status: 403
        end
      end

      def update
        @establishment = Establishment.find(params[:id])
        if current_user.has_role?(:admin) || current_user.has_role?(:manager, @establishment)
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
        @establishment = Establishment.find(params[:id])
        if current_user.has_role?(:admin) || current_user.has_role?(:manager, @establishment)
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
        params.require(:establishment).permit(:name, :image_url, :description, :user_id)
      end
    end
  end
end
