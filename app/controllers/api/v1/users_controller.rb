module Api
  module V1
    class UsersController < BaseController
      respond_to :json
      before_filter :authenticate_user_from_token!
      # before_filter :admin_only!, only: [:index]
      # before_filter :auth_only!, except: [:index]

      def index
        if current_user.admin?
          return render json: User.all
        else
          return render json: {}, status: 403
        end
      end

      def show
        user = User.find(params[:id])
        puts user.inspect
        if current_user.admin? || current_user == user
          us = UserSerializer.new(user);
          puts us.to_json
          return render json: User.find(params[:id])
        else
          return render json: {}, status: 403
        end
      end

      def update
        if current_user.admin?
          @user = User.find(params[:id])
          update_params = sport_id_list_to_sports_for_update
          puts update_params.inspect
          if @user.update!(update_params)
            return render json: @user
          else
            return render json: { :errors => 'User not updated' }, status: 422
          end
        else
          return render json: {}, status: 403
        end
      end

      private

      def sport_id_list_to_sports_for_update
        update_params = user_params
        sport_ids = update_params[:sports]
        sports = []
        if sport_ids.any?
          sports = sport_ids.map{|sid| Sport.find_by_id(sid)}.compact.uniq
          puts sports
        end
        update_params[:sports] = sports
        update_params
      end

      def user_params
        params.require(:user).permit(:name, :admin, :email, :city, :state, :zip, :current_password, :password, :password_confirmation, {:sports=>[]})
      end
    end
  end
end
