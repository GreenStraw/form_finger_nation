class Api::V1::PartyInvitationsController < Api::V1::BaseController
  before_filter :authenticate_user_from_token!, only: [:bulk_create_from_user, :bulk_create_from_email]

  def index
    respond_with @party_invitations
  end

  def show
    respond_with @party_invitation
  end

  def accept
    @party_invitation = PartyInvitation.find(params[:id])
    @party_invitation.status = PartyInvitation::ACCEPTED
    @party_invitation.save
    respond_with @party_invitation, :location=>api_v1_party_invitations_path
  end

  private

  def accept_params
    params.require(:party_invitation).permit(:id)
  end
end
