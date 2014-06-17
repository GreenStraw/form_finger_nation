class PartyInvitationMailer < ActionMailer::Base
  default from: 'test@ffn.com'

  def non_member_private_watch_party_invitation_email(invitation)
    @to = invitation.unregistered_invitee_email
    @inviter = invitation.inviter
    @uuid = invitation.uuid
    @party = invitation.party
    @party_address = @party.address
    @url = "#{ENV['WEB_APP_URL']}/party_invitations/non_member_rsvp/#{@uuid}"
    mail(to: @to, subject: 'You have been invited to a watch party on Foam Finger Nation!')
  end

  def member_watch_party_invitation_email(invitation)
    @to = invitation.user.email
    @inviter = invitation.inviter
    @uuid = invitation.uuid
    @party = invitation.party
    @party_address = nil
    if @party.isPrivate
      @party_address = @party.address
    else
      @party_address = @party.venue.address
    end
    @url = "#{ENV['WEB_APP_URL']}/party_invitations/member_rsvp/#{@uuid}"
    mail(to: @to, subject: 'You have been invited to a watch party on Foam Finger Nation!')
  end
end
