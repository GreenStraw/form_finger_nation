class Api::V1::PartyInvitationsController < Api::V1::BaseController
  before_filter :authenticate_user_from_token!, only: [:bulk_create_from_user, :bulk_create_from_email]

  def index
    return render json: PartyInvitation.all
  end

  def show
    uuid = params[:id]
    @invitations = PartyInvitation.where(:uuid => uuid)
    if @invitations.present?
      return render json: @invitations.first
    else
      return render json: nil
    end
  end

  def claim_by_email
    uuid = params[:id]
    @invitations = PartyInvitation.where(:uuid => uuid)
    if @invitations.present?
      invitation = @invitations.first
      party = invitation.party
      if party.party_reservations.where(:unregistered_rsvp_email => invitation.unregistered_invitee_email).count == 0
        rsvp = PartyReservation.new(unregistered_rsvp_email: invitation.unregistered_invitee_email,
                                    party_id: invitation.party_id)
        if rsvp.save!
          invitation.update_attribute(:claimed, true)
        else
          return render json: nil, status: 422
        end
      end
      return render json: {}, status: 200
    else
      return render json: nil, status: 422
    end
  end

  def claim_by_user
    uuid = params[:id]
    invitations = PartyInvitation.where(:uuid => uuid)
    user = nil
    invitation = nil
    if invitations.present?
      invitation = invitations.first
      user = User.find_by_id(invitation.user_id)
    end
    if user.present?
      party = invitation.party
      if !party.attendees.include?(user)
        party.attendees << user
        if party.save!
          invitation.update_attribute(:claimed, true)
        else
          return render json: nil, status: 422
        end
      end
      return render json: {}, status: 200
    else
      return render json: nil, status: 422
    end
  end

  def bulk_create_from_user
    user_ids = params[:user_ids].split(',')
    inviter_id = params[:inviter_id]
    party_id = params[:party_id]
    invitations = []
    user_ids.each do |user_id|
      if PartyInvitation.where(user_id: user_id, party_id: party_id).empty?
        @invitation = PartyInvitation.new(user_id: user_id,
                                          inviter_id: inviter_id,
                                          party_id: party_id)
        if @invitation.save!
          invitations << @invitation
          PartyInvitationMailer.member_watch_party_invitation_email(@invitation).deliver
        end
      end
    end
    return render json: invitations
  end

  def bulk_create_from_email
    email_addresses = params[:email_addresses]
    inviter_id = params[:inviter_id]
    party_id = params[:party_id]
    split_emails = email_addresses.split(',')
    invitations = []
    split_emails.each do |email|
      if PartyInvitation.where(unregistered_invitee_email: email, party_id: party_id).empty?
        @invitation = PartyInvitation.new(unregistered_invitee_email: email,
                                          inviter_id: inviter_id,
                                          party_id: party_id)
        if @invitation.save!
          invitations << @invitation
          PartyInvitationMailer.non_member_private_watch_party_invitation_email(@invitation).deliver
        end
      end
    end
    return render json: invitations
  end

end
