ActionMailer::Base.default_url_options = {
  # :host => ENV['SMTP_DEFAULT_URL']
  :host => 'localhost:3000'
}

ActionMailer::Base.raise_delivery_errors = ENV['SMTP_RAISE_DELIVERY_ERRORS']
ActionMailer::Base.smtp_settings = {
  :address              => ENV['SMTP_ADDRESS'],
  :port                 => ENV['SMTP_PORT'],
  :domain               => ENV['SMTP_DOMAIN'],
  :user_name            => ENV['SMTP_USER_NAME'],
  :password             => ENV['SMTP_PASSWORD'],
  :authentication       => 'plain',
  :enable_starttls_auto => true
}
