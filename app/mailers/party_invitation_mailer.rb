class PartyInvitationMailer < ActionMailer::Base

  def invitation_email(invitation)
    @member = invitation.user_id.present?
    @to = invitation.email
    @inviter = invitation.inviter
    @uuid = invitation.uuid
    @party = invitation.party
    @party_address = nil
    @party.is_private ? @party_address = @party.address : @party_address = @party.venue.address
    if Rails.env.production?
      @url = "http://foamfingernation.com/parties/#{@party.id}"
    else
      @url = "http://localhost:3000/parties/#{@party.id}"
    end
    mail(to: @to, subject: 'You have been invited to a watch party on Foam Finger Nation!')
  end

end
