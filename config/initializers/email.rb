ActionMailer::Base.default_url_options = {
  :host => ENV['SMTP_DEFAULT_URL']
}
ActionMailer::Base.default from: ENV['MAILER_SEND_AS']
ActionMailer::Base.raise_delivery_errors = ENV['SMTP_RAISE_DELIVERY_ERRORS']
