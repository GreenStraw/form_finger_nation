class PasswordMailer < ActionMailer::Base
  default from: 'test@ffn.com'

  def password_reset_email(user)
    @to = user.email
    @password = user.password
    @url = "#{ENV['WEB_APP_URL']}/login"
    mail(to: @to, subject: 'Password reset')
  end
end
