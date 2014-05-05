module Api
  module V1
    class BaseController < ApplicationController
      respond_to :json
      # before_filter :cors_preflight_check
      # after_filter :cors_set_access_control_headers
      before_action :default_json

      def current_user
        user_email = request.headers['auth-email']
        user_token = request.headers['auth-token']
        return nil unless user_token
        User.find_by authentication_token: user_token
      end

      protected

      def default_json
        request.format = :json if params[:format].nil?
      end

      def auth_only!
        render json: {}, status: 401 unless current_user
      end

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

      def cors_set_access_control_headers
        puts 'set access'
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS, PUT'
        headers['Access-Control-Allow-Headers'] = '*'
        headers['Access-Control-Max-Age'] = "1728000"
      end

      def cors_preflight_check
        puts 'preflight check'
        if request.method == :options
          headers['Access-Control-Allow-Origin'] = '*'
          headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS, PUT'
          headers['Access-Control-Allow-Headers'] = '*'
          headers['Access-Control-Max-Age'] = '1728000'
          render :text => '', :content_type => 'text/plain'
        end
      end
    end
  end
end
