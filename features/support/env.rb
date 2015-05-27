require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  ENV["RAILS_ENV"] ||= "test"
  require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
  
  require 'simplecov'
  SimpleCov.start 'rails'
  
  require 'cucumber/rails'
  require 'email_spec' # add this line if you use spork
  require 'email_spec/cucumber'
  require 'factory_girl_rails'

  require 'selenium-webdriver'
  require 'capybara/cucumber'
  require 'rspec/expectations'
  
  require 'chronic'
  require 'timecop/timecop'
  
  # require 'cucumber/rails/capybara_javascript_emulation' # Lets you click links with onclick javascript handlers without using @culerity or @javascript
  # Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
  # order to ease the transition to Capybara we set the default here. If you'd
  # prefer to use XPath just remove this line and adjust any selectors in your
  # steps to use the XPath syntax.
  Capybara.default_selector = :css
  
  # If you set this to false, any error raised from within your app will bubble 
  # up to your step definition and out to cucumber unless you catch it somewhere
  # on the way. You can make Rails rescue errors and render error pages on a
  # per-scenario basis by tagging a scenario or feature with the @allow-rescue tag.
  ActionController::Base.allow_rescue = false
  
  # If you set this to true, each scenario will run in a database transaction.
  # You can still turn off transactions on a per-scenario basis, simply tagging 
  # a feature or scenario with the @no-txn tag. If you are using Capybara,
  # tagging with @culerity or @javascript will also turn transactions off.
  Cucumber::Rails::World.use_transactional_fixtures = true
  
  # How to clean your database when transactions are turned off. See
  # http://github.com/bmabey/database_cleaner for more info.
  if defined?(ActiveRecord::Base)
    begin
      require 'database_cleaner'
      DatabaseCleaner.strategy = :truncation
    rescue LoadError => ignore_if_database_cleaner_not_present
    end
  end
  
  # run tests headless using webkit - good speed
  # to run on headless server install xvfb and use the following command
  # xvfb-run bundle exec cucumber
  Capybara.server_port = '8000'
  Capybara.app_host = 'http://localhost:8000'
  Capybara.javascript_driver = :webkit
  
  # # run tests against firefox browser using selenium - if you want to see what's happening
  # Capybara.register_driver :selenium do |app|
  #   Capybara::Selenium::Driver.new(app, :browser => :firefox)
  # end
  # Capybara.javascript_driver = :selenium
  
  # # run tests againser chrome browser - a curiosity but doesn't work well
  # # requires installation of chrome driver
  # # https://code.google.com/p/chromium/downloads/detail?name=chromedriver_mac_16.0.902.0.zip&can=2&q=
  # # so far i've not had luck with this
  # Capybara.register_driver :chrome do |app|
  #   Capybara::Selenium::Driver.new(app, :browser => :chrome)
  # end
  # Capybara.javascript_driver = :chrome
end

Spork.each_run do
  require File.expand_path(File.dirname(__FILE__) + '/test_data')
  include TestData
  
  Before do
    test_data_setup
  end

  After do
    test_data_teardown
  end
    
  # will start a new browser session if the last one has gone stale
  After("@javascript") do |scenario|
    if scenario.exception.is_a? Timeout::Error
      # restart driver if a timeout has occurred
      Capybara.send(:session_pool).delete_if { |key, value| key =~ /selenium/i }
    end
  end
  
end
