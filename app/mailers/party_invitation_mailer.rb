class PartyInvitationMailer < ActionMailer::Base
  default from: 'test@ffn.com'

  def invitation_email(invitation)
    puts invitation.inspect
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
    @url = "#{ENV['WEB_APP_URL']}/party_invitations/member_rsvp/#{@uuid}"
    puts @to
    mail(to: @to, subject: 'You have been invited to a watch party on Foam Finger Nation!')
  end
end
