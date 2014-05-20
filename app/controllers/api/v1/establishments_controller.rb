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
          create_params = establishment_params
          create_params[:user] = user_id_to_user
          @establishment = Establishment.new(create_params)
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
          update_params = establishment_params
          if update_params[:user].nil?
            update_params[:user] = @establishment.user_id
          end
          update_params[:user] = user_id_to_user
          if @establishment.update!(update_params)
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

      def user_id_to_user
        update_params = establishment_params
        if update_params[:user].present?
          user_id = update_params[:user]
          User.find_by_id(user_id)
        else
          nil
        end
      end

      def find_lat_long

      end

      def establishment_params
        params.require(:establishment).permit(:name, :image_url, :description, :user, :street1, :street2, :city, :state, :zip, :latitude, :longitude)
      end
    end
  end
end
