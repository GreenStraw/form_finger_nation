class UserMailer < ActionMailer::Base

  def welcome_email(user)
    @to = user.email
    @user = user
    @url = "http://www.foamfingernation.com/login"
    mail(to: @to, from: '"Foam Finger Nation" <Info@foamfingernation.com>', subject: 'Welcome to Foam Finger Nation!')
  end

  def alumni_group_email(user)
    @to = user.email
    @bcc = ['alumnigroups@foamfingernation.com']
    @user = user
    @url = "http://www.foamfingernation.com/login"
    mail(to: @to, bcc: @bcc, from: '"Foam Finger Nation" <Alumnigroups@foamfingernation.com>', subject: 'Welcome to Foam Finger Nation!')
  end

  def venue_email(user)
    @to = user.email
    @bcc = ['Sportsbars@foamfingernation.com']
    @user = user
    @url = "http://www.foamfingernation.com/login"
    mail(to: @to, bcc: @bcc, from: '"Foam Finger Nation" <Sportsbars@foamfingernation.com>', subject: 'Welcome to Foam Finger Nation!')
  end
end
 