class PartyVerificationMailer < ActionMailer::Base
  default from: 'test@ffn.com'

  def watch_party_host_verification_email(verification)
    @to = verification.user.email
    @party = verification.party
    mail(to: @to, subject: 'Your watch party has been verified by the venue!')
  end
end
