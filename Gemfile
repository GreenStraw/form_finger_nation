source 'https://rubygems.org'

ruby '2.0.0' # or 1.9.3

gem 'rails', '~> 4.0'
gem 'pg', '~> 0.14'
gem 'unicorn', '~> 4.6'

gem 'jquery-rails', '~> 3.0'
gem 'coffee-rails', '~> 4.0'
gem 'sass-rails', '~> 4.0'
gem 'uglifier', '~> 2.1'
gem 'twitter-bootstrap-rails'

gem 'rolify'
gem 'devise', '3.0.0' # server-side authentication
                                # 3.1 removes token auth
gem 'omniauth-facebook'
gem 'bcrypt-ruby', '~> 3.0' # password encryption

gem 'active_model_serializers', '~> 0.7' # json tat conforms to ember-data expectationh
gem 'rack-cors', :require => 'rack/cors'

gem 'geocoder'

group :test do
  gem 'rspec-rails', '~> 2.13' # test framework
  gem 'spork', '>= 1.0.0rc3', '< 2.0' # speedier tests
  gem 'guard-rspec', '~> 3.0' # watch app files and auto-re-run tests
  gem 'guard-spork', '~> 1.5' # spork integration
  gem 'launchy'
  gem 'database_cleaner', '~> 1.0' # cleanup database in tests
  gem 'fabrication', '~> 2.6' # model stubber
  gem 'shoulda', '~> 3.3' # model spec tester
  gem 'rb-inotify', require: false  # Linux file notification
  gem 'rb-fsevent', require: false  # OSX file notification
  gem 'rb-fchange', require: false  # Windows file notification
end

group :development, :test do
  gem "qunit-rails"
end

group :production do
  gem 'rails_12factor', '~> 0.0' # tweaks for heroku
  gem 'newrelic_rpm', '~> 3.5' # prevent heroku from idling
end
