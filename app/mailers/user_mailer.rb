class UserMailer < ActionMailer::Base

  def welcome_email(user)
    @to = user.email
    @user = user
    @url = new_user_session_url
    mail(to: @to, subject: 'Welcome to Foam Finger Nation!')
  end

  def alumni_group_email(user)
    @to = user.email
    @bcc = ['alumnigroups@foamfingernation.com']
    @user = user
    @url = new_user_session_url
    mail(to: @to, bcc: @bcc, from: '"Foam Finger Nation" <Alumnigroups@foamfingernation.com>', subject: 'Welcome to Foam Finger Nation!')
  end

  def venue_email(user)
    @to = user.email
    @bcc = ['Sportsbars@foamfingernation.com']
    @user = user
    @url = new_user_session_url
    mail(to: @to, bcc: @bcc, from: '"Foam Finger Nation" <Sportsbars@foamfingernation.com>', subject: 'Welcome to Foam Finger Nation!')
  end
end
