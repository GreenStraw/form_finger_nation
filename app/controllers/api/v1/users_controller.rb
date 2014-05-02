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
        if current_user.admin? || current_user == user
          return render json: User.find(params[:id])
        else
          return render json: {}, status: 403
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :city, :state, :zip, :password, :password_confirmation, :remember_me, :admin)
      end
    end
  end
end
