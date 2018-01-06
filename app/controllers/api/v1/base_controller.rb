module Api
  module V1 
    class BaseController < ApplicationController
        #skip_before_action :verify_authenticity_token, raise: false

        # token validation per tenant should be implemented
        #before_action :validate_token
        
        # Prevent CSRF attacks by raising an exception.
        # For APIs, you may want to use :null_session instead.
        protect_from_forgery with: :null_session

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
    end
  end
end
