source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.1.4'

# Use pg as the database for Active Record
gem 'pg'
gem "font-awesome-rails"
# Use SCSS for stylesheets
gem 'sass-rails' #, '~> 4.0.2'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier' #, '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails' #, '~> 4.0.0'
gem 'binding_of_caller'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks' # turbolinks investigate on its purpose and impact on site later

# help migrate data from old database
gem 'yaml_db'

gem 'sprockets-rails', '2.3.3'

gem 'shareable'
gem 'active_model_serializers' #, '~> 0.7' # json tat conforms to ember-data expectationh
gem 'bootstrap-datepicker-rails'
# pick enumerable or rolify for user roles
gem 'rolify'
gem 'enumerize', '0.6.1' # an issue in 0.7.0 causes app error when enumerized state is blank and scope and predicates flags are passed
# we use the custom code for datatable in app/assets/javascripts/third_party

gem 'bcrypt' # password encryption

gem 'awesome_nested_set' #, '~>3.0.0.rc5'
gem 'rack-cors', :require => 'rack/cors'

# digital ocean official V2 API client
#gem 'droplet_kit'

gem 'gmaps4rails'
gem 'underscore-rails'
gem 'twitter'
gem 'geocoder'
gem 'geokit-rails'
gem 'acts_as_commentable_with_threading'
gem 'stripe'
gem 'aws-sdk'
gem 'httparty'

gem 'carrierwave'
gem 'fog'
gem 'mini_magick'

gem "select2-rails"


# Use unicorn as the app server
#gem 'unicorn'

# whenever for managing cron jobs
gem 'whenever'#,                 '~> 0.9.0'
# dotenv for managing app environment confirugation
gem 'dotenv-rails'#,             '~> 0.9.0'
# new relic for app and server monitoring
gem 'newrelic_rpm'
# excpetion notification for problem notification
gem 'exception_notification'#,   '~> 4.0.1'
#letter opener
gem 'letter_opener', group: :development
gem "koala", "~> 1.10.0rc"


# =========================================================
gem 'devise'#,                   '~>3.2'
gem 'omniauth'
gem 'omniauth-oauth2'
gem 'omniauth-facebook'#, '1.4.0' #important: 1.4.1 is broken!!!
gem 'omniauth-twitter'
gem 'milia' #gem 'milia', github: 'jekuno/milia', branch: 'issue#68'
gem 'cancancan'#, 				'~> 2.0'
gem 'twitter-bootstrap-rails'
gem 'therubyracer'
gem 'less-rails'
# =========================================================

gem 'recaptcha', require: 'recaptcha/rails'
gem 'activerecord-session_store'
gem 'will_paginate'

gem 'friendly_id'



group :development, :test do
  gem 'annotate'#,                 '>= 2.5.0'
  gem 'awesome_print'
  gem 'byebug'
  gem 'pry-byebug'
  #gem "capybara"
  #gem "capybara-webkit"
  gem "codeclimate-test-reporter" , require: false
  gem 'cucumber-rails'            , require: false
  gem 'database_cleaner'#,         '~> 1.1.1'
  gem 'email_spec'#,               '~> 1.5.0'
  gem 'fabrication'#, '~> 2.6' # model stubber
  gem 'guard-rspec'#, '~> 3.0' # watch app files and auto-re-run tests
  gem 'guard-spork'#, '~> 1.5' # spork integration
  gem 'launchy'
  gem "qunit-rails"
  gem 'railroady'#,                '~> 1.1.0'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'shoulda'#, '~> 3.3' # model spec tester
  gem 'simplecov'#,                '~> 0.7.1', require: false
  gem 'spork'
  gem 'stripe-ruby-mock'#, '~> 1.10.1.7'
  gem 'timecop'#,                  '~> 0.6.2.2'
end


# Use Capistrano for deployment
group :development do
  gem 'capistrano',             '~> 3.1.0'
  gem 'capistrano-rails',       '~> 1.1.1'
  gem 'capistrano-bundler',     '~> 1.1.2'
  gem "better_errors"
  gem 'capistrano-rbenv'
  gem 'capistrano-maintenance', '~> 1.0', require: false
  gem "figaro"
end

group :production do
  #gem 'rails_12factor', '~> 0.0' # tweaks for heroku
  
  # Use puma as the app server
  gem 'puma'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

