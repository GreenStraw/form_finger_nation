class Api::V1::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token

  # token validation per tenant should be implemented
  before_action :validate_token
  
  respond_to :json

  def current_user
    user_email = request.headers['auth-email']
    user_token = request.headers['auth-token']
    return nil unless user_token
    user = User.find_by authentication_token: user_token

    user.current_latitude = nil

    return nil
  end

  private

  def validate_token
    render json: ["Access Denied"], status: 403 unless request.headers['api-token'] == Tenant.current_tenant.api_token
  end
end
