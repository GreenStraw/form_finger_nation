class EndorsementMailer < ActionMailer::Base

  def endorsement_requested_email(endorsement_request)
    admin = User.with_role(:team_admin, endorsement_request.team).first
    if admin.present?
      @to = admin.email
      @user = endorsement_request.user
      @bcc = ["calvincarter.160@gmail.com", "sayrooj@gmail.com", "rhettlg@yahoo.com"]
      mail(to: @to, bcc: @bcc, subject: 'Foam Finger Nation Endorsement Request')
    end
  end
  
end