module Api
  module V1
    class SessionsController < Devise::SessionsController
      skip_before_action :verify_authenticity_token
      skip_before_filter :authenticate_user_from_token!, only: [:create]

      def create
        unless (params[:email] && params[:password]) || (params[:remember_token]) || (params[:auth_token])
          return missing_params
        end

        @user = if params[:remember_token]
          user_from_remember_token
        elsif params[:auth_token]
          user_from_remember_token
        else
          user_from_credentials
        end
        return invalid_credentials unless @user
        @user.ensure_authentication_token!

        # return unconfirmed unless @user.confirmed?

        data = {
          user_id: @user.id,
          auth_token: @user.authentication_token,
          auth_email: @user.email,
          user_name: @user.username,
          user_admin: @user.has_role?(:admin)
        }
        if params[:remember]
          @user.remember_me!
          data[:remember_token] = remember_token
        end
        render json: data, status: 201
      end

      def destroy
        return missing_params unless params[:auth_token]

        @user = User.find_by authentication_token: params[:auth_token]
        return invalid_credentials unless @user

        @user.reset_authentication_token!
        @user.forget_me!

        render json: { user_id: @user.id }, status: 200
      end

      private

      def remember_token
        data = User.serialize_into_cookie @user
        "#{data.first.first}-#{data.last}"
      end

      def user_from_credentials
        if user = User.find_for_database_authentication(email: params[:email])
          if user.valid_password? params[:password]
            user
          end
        end
      end

      def user_from_remember_token
        id, identifier = params[:remember_token].split '-'
        User.serialize_from_cookie id, identifier
      end

      def missing_params
        render json: {}, status: 400
      end

      def invalid_credentials
        render json: {}, status: 401
      end

      def unconfirmed
        render json: {error: 'unconfirmed'}, status: 401
      end
    end
  end
end
