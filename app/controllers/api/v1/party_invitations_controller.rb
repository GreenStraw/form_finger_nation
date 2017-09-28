class Api::V1::PartyInvitationsController < Api::V1::BaseController
  # before_action :authenticate_user_from_token!

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
    @party = Party.where(id: @party_invitation.party_id).first
    PartyReservation.create_for(@party_invitation.email, @party)
    respond_with @party_invitation, :location=>api_v1_party_invitations_path
  end

  private

  def accept_params
    params.require(:party_invitation).permit(:id)
  end
end
