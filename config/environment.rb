# Load the Rails application.
require File.expand_path('../application', __FILE__)

require 'dotenv' ; Dotenv.load ".env.#{Rails.env}"

# Initialize the Rails application.
Baseapp::Application.initialize!
