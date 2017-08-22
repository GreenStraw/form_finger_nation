class UserMailer < ActionMailer::Base

  def welcome_email(user)
    @to = user.email
    @user = user
    @url = "https://www.foamfingernation.com/login"
    @bcc = ["calvincarter.160@gmail.com", "sayrooj@gmail.com", "rhettlg@yahoo.com"]
    mail(to: @to, bcc: @bcc, from: '"Foam Finger Nation" <Info@foamfingernation.com>', subject: 'Welcome to Foam Finger Nation!')
  end

  def alumni_group_email(user)
    @to = user.email
    @bcc = ["alumnigroups@foamfingernation.com","calvincarter.160@gmail.com", "sayrooj@gmail.com", "rhettlg@yahoo.com"]
    @user = user
    @url = "https://www.foamfingernation.com/login"
    mail(to: @to, bcc: @bcc, from: '"Foam Finger Nation" <Alumnigroups@foamfingernation.com>', subject: 'Welcome to Foam Finger Nation!')
  end

  def venue_email(user)
    @to = user.email
    @bcc = ["Sportsbars@foamfingernation.com", "calvincarter.160@gmail.com", "sayrooj@gmail.com", "rhettlg@yahoo.com"]
    @user = user
    @url = "https://www.foamfingernation.com/login"
    mail(to: @to, bcc: @bcc, from: '"Foam Finger Nation" <Sportsbars@foamfingernation.com>', subject: 'Welcome to Foam Finger Nation!')
  end
end
 