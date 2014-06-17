module Api
  module V1
    class BaseController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :default_json, :validate_token
      respond_to :json

      def current_user
        user_email = request.headers['auth-email']
        user_token = request.headers['auth-token']
        return nil unless user_token
        User.find_by authentication_token: user_token
      end

      private


      def validate_token
        render json: ["Access Denied"], status: 403 unless request.headers['api-token'] == Tenant.current_tenant.api_token
      end

      def default_json
        request.format = :json if params[:format].nil?
      end

      def auth_only!
        render json: {}, status: 401 unless current_user
      end
    end
  end
end
