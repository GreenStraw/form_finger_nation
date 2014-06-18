# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  ENV["RAILS_ENV"] ||= 'test'
  require 'simplecov'
  SimpleCov.start 'rails'

  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'email_spec'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  # Checks for pending migrations before tests are run.
  # If you are not using ActiveRecord, you can remove this line.
  ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

  RSpec.configure do |config|
    config.before(:each) do
      Address.any_instance.stub(:geocode).and_return([1,1])
    end
    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr

    # rspec-rails 3 will no longer automatically infer an example group's spec type
    # from the file location. You can explicitly opt-in to this feature using this
    config.infer_spec_type_from_file_location!

    # deprecation messages will raise errors
    config.raise_errors_for_deprecations!

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"
    config.include Rails.application.routes.url_helpers, :type => :acceptance
    config.include Devise::TestHelpers, :type => :controller
    config.include DeviseHelpers, :type => :controller
    config.extend DeviseHelpers, :type => :controller
    config.include TenantHelpers, :type => :controller
    config.include EmailSpec::Helpers
    config.include EmailSpec::Matchers

    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
    end
    config.before(:each) do
      DatabaseCleaner.start
      
      tenant = Fabricate(:test_tenant)
      Tenant.set_current_tenant tenant
    end
    config.after(:each) do
      DatabaseCleaner.clean
    end

  end

end

Spork.each_run do
  # This code will be run each time you run your specs.

end
