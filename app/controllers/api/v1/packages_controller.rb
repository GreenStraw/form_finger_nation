module Api
  module V1
    class PackagesController < BaseController
      respond_to :json
      before_filter :authenticate_user_from_token!, only: [:create, :update, :destroy]

      def index
        return render json: Package.all
      end

      def show
        return render json: Package.find(params[:id])
      end

      def create
        @package = Package.new(package_params)
        venue = Venue.find_by_id(@package.venue_id)
        if current_user.has_role?(:admin) || (venue.present? &&
                                              current_user.has_role?(:manager, venue))
          if @package.save
            return render json: @package
          else
            return render json: { :errors => @package.errors.full_messages }, status: 422
          end
        else
          return render json: {}, status: 403
        end
      end

      def update
        @package = Package.find(params[:id])
        venue = @package.venue
        if current_user.has_role?(:admin) || (venue.present? &&
                                              current_user.has_role?(:manager, venue))
          if @package.update!(package_params)
            return render json: @package
          else
            return render json: { :errors => @package.errors.full_messages }, status: 422
          end
        else
          return render json: {}, status: 403
        end
      end

      def destroy
        @package = Package.find(params[:id])
        venue = @package.venue
        if current_user.has_role?(:admin) || (venue.present? &&
                                              current_user.has_role?(:manager, venue))
          if @package.destroy
            return render json: {}, status:200
          else
            return render json: { :errors => @package.errors.full_messages }, status: 422
          end
        else
          return render json: {}, status: 403
        end
      end

      private

      def package_params
        params.require(:package).permit(:name, :description, :image_url, :price, :active, :start_date, :end_date, :venue_id)
      end
    end
  end
end
