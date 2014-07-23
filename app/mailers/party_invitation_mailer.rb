class PartyInvitationMailer < ActionMailer::Base

  def invitation_email(invitation)
    @member = invitation.user_id.present?
    @to = invitation.email
    @inviter = invitation.inviter
    @uuid = invitation.uuid
    @party = invitation.party
    @party_address = nil
    if @party.is_private
      @party_address = @party.address
    else
      @party_address = @party.venue.address
    end
    @url = "foamfinger://#{@party.id}"
    mail(to: @to, subject: 'You have been invited to a watch party on Foam Finger Nation!')
  end
end
