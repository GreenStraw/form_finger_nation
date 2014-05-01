module Api
  module V1
    class UsersController < BaseController
      respond_to :json
      before_filter :authenticate_user_from_token!
      # before_filter :admin_only!, only: [:index]
      # before_filter :auth_only!, except: [:index]

      def index
        if current_user.admin?
          render json: User.all
        else
          render json: {}, status: 403
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

      def authenticate_user_from_token!
        user_email = request.headers['auth-email'].presence
        user_token = request.headers['auth-token'].presence
        return render json: {}, status: 401 unless user_email && user_token
        user       = user_email && User.find_by_email(user_email)

        # Notice how we use Devise.secure_compare to compare the token
        # in the database with the token given in the params, mitigating
        # timing attacks.
        if user && Devise.secure_compare(user.authentication_token, user_token)
          sign_in user, store: false
        else
          return render json: {}, status: 401
        end
      end
      def user_params
        params.require(:user).permit(:name, :email, :city, :state, :zip, :password, :password_confirmation, :remember_me, :admin)
      end
    end
  end
end
