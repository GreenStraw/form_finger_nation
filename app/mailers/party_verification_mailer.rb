class PartyVerificationMailer < ActionMailer::Base
  default from: 'test@ffn.com'

  def watch_party_host_verification_email(party)
    @to = party.organizer.email
    @party = party
    mail(to: @to, subject: 'Your watch party has been verified by the venue!')
  end
end
