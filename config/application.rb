require File.expand_path('../boot', __FILE__)
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Baseapp
  class Application < Rails::Application
    #  For faster asset precompiles, you can partially load your application.
    #  In that case, templates cannot see application objects or methods.
    #  Heroku requires this to be false.
    config.assets.initialize_on_precompile = false

    config.autoload_paths << Rails.root.join('lib')

    # In older versions of Rails (< 4) helpers that had the same name with the controllers 
    # were only available in their corresponding controller and views, for example the 
    # helpers in BooksHelper were available in BooksController and /views/books/*. 
    # This is no longer true in Rails 4 each controller will include all 
    # helpers. If you prefer the old behavior you can still get to it by 
    # setting inclue_all_helpers = false
    # https://mixandgo.com/blog/the-beginners-guide-to-rails-helpers
    # http://blog.bigbinary.com/2016/06/26/rails-add-helpers-method-to-ease-usage-of-helper-modules-in-controllers.html
    config.action_controller.include_all_helpers = true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Central Time (US & Canada)'
    config.active_record.default_timezone = :local #:local Or :utc

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options, :put, :delete, :patch]
      end
    end

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
