class Api::V1::EndorsementRequestsController < Api::V1::BaseController
  before_action :authenticate_user_from_token!
  load_and_authorize_resource

  def index
    respond_with @endorsement_requests
  end

  def show
    respond_with @endorsement_request
  end

  def create
    @endorsement_request.save
    @endorsement_request.send_endorsement_requested_email
    respond_with @endorsement_request, :location=>api_v1_endorsement_requests_path
  end

  def update
    @endorsement_request.update(endorsement_request_params)
    respond_with @endorsement_request, :location=>api_v1_endorsement_requests_path
  end

  private

  def endorsement_request_params
    params.require(:endorsement_request).permit(:user_id, :team_id)
  end
end
