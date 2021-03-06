class PartyInvitationMailer < ActionMailer::Base
  default from: 'watchparty@foamfingernation.com'

  def invitation_email(invitation)
    @member = invitation.user_id.present?
    @to = invitation.email
    @inviter = invitation.inviter
    @bcc = ["calvincarter.160@gmail.com", "sayrooj@gmail.com", "rhettlg@yahoo.com"]
    @uuid = invitation.uuid
    @party = invitation.party
    @party_address = nil
    @party.is_private ? @party_address = @party.address : @party_address = @party.venue.address
    @url = "#{ENV['SMTP_DEFAULT_URL']}/parties/#{@party.id}"

    mail(to: @to, bcc: @bcc, subject: 'You have been invited to a watch party on Foam Finger Nation!')
  end

end
 