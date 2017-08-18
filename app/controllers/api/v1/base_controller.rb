class Api::V1::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token

  # token validation per tenant should be implemented
  before_action :validate_token
  
  respond_to :json



  private

  def validate_token
    render json: ["Access Denied"], status: 403 unless request.headers['api-token'] == Tenant.current_tenant.api_token
  end
end
