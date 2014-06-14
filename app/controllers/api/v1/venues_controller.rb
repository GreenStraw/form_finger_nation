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
          @venue = Venue.new(venue_params)
          if @venue.save
            current_user.add_role(:manager, @venue)
            return render json: @venue
          else
            return render json: { :errors => @venue.errors.full_messages }, status: 422
          end
        else
          return render json: {}, status: 403
        end
      end

      def update
        @venue = Venue.find(params[:id])
        if current_user.has_role?(:admin) || current_user.has_role?(:manager, @venue)
          if @venue.update!(venue_params)
            return render json: @venue
          else
            return render json: { :errors => @venue.errors.full_messages }, status: 422
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
            return render json: { :errors => @venue.errors.full_messages }, status: 422
          end
        else
          return render json: {}, status: 403
        end
      end

      private

      def venue_params
        params.require(:venue).permit(:name, :image_url, :description, :address, {:favorite_team_ids=>[], :favorite_sport_ids=>[], :party_ids=>[]})
      end
    end
  end
end
