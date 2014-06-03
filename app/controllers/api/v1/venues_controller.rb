module Api
  module V1
    class VenuesController < BaseController
      before_filter :authenticate_user_from_token!, only: [:create, :update, :destroy]
      respond_to :json

      def index
        return render json: Venue.all
      end

      def show
        return render json: Venue.find(params[:id])
      end

      def create
        if current_user.has_any_role?(:admin, :venue_manager)
          create_params = venue_params
          create_params[:user] = user_id_to_user
          @venue = Venue.new(create_params)
          if @venue.save
            current_user.add_role(:manager, @venue)
            return render json: @venue
          else
            return render json: { :errors => 'Venue not created' }, status: 422
          end
        else
          return render json: {}, status: 403
        end
      end

      def update
        @venue = Venue.find(params[:id])
        if current_user.has_role?(:admin) || current_user.has_role?(:manager, @venue)
          update_params = venue_params
          if update_params[:user].nil?
            update_params[:user] = @venue.user_id
          end
          update_params[:user] = user_id_to_user
          if @venue.update!(update_params)
            return render json: @venue
          else
            return render json: { :errors => 'Venue not updated' }, status: 422
          end
        else
          return render json: {}, status: 403
        end
      end

      def destroy
        @venue = Venue.find(params[:id])
        if current_user.has_role?(:admin) || current_user.has_role?(:manager, @venue)
          if @venue.destroy
            return render json: {}, status:200
          else
            return render json: { :errors => 'Venue not deleted' }, status: 422
          end
        else
          return render json: {}, status: 403
        end
      end

      private

      def user_id_to_user
        update_params = venue_params
        if update_params[:user].present?
          user_id = update_params[:user]
          User.find_by_id(user_id)
        else
          nil
        end
      end

      def find_lat_long

      end

      def venue_params
        params.require(:venue).permit(:name, :image_url, :description, :user, :address)
      end
    end
  end
end
