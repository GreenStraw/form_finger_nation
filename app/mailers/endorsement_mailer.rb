class EndorsementMailer < ActionMailer::Base
  default from: 'test@ffn.com'

  def endorsement_requested_email(endorsement_request)
    admin = User.with_role(:team_admin, endorsement_request.team).first
    if admin.present?
      @to = admin.email
      @user = endorsement_request.user
      mail(to: @to, subject: 'Foam Finger Nation Endorsement Requets')
    end
  end
end
