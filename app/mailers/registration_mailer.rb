class RegistrationMailer < ActionMailer::Base
  default from: 'test@ffn.com'

  def welcome_email(user)
    @to = user.email
    @password = user.password
    @url = "#{ENV['WEB_APP_URL']}/login"
    mail(to: @to, subject: 'Welcome to Foam Finger Nation!')
  end

  def facebook_welcome_email(user)
    @to = user.email
    @url = "#{ENV['WEB_APP_URL']}/login"
    mail(to: @to, subject: 'Welcome to Foam Finger Nation!')
  end
end
