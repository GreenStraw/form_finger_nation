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

    # Adding Webfonts to the Asset Pipeline
    config.assets.precompile << Proc.new { |path|
      if path =~ /\.(eot|svg|ttf|woff|otf)\z/
        true
      end
    }

    # uncomment to ensure a common layout for devise forms
    config.to_prepare do   # Devise
      Devise::SessionsController.layout "sign"
      Devise::RegistrationsController.layout "sign"
      Devise::ConfirmationsController.layout "sign"
      Devise::PasswordsController.layout "sign"
    end   # Devise

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Central Time (US & Canada)'

    config.action_controller.include_all_helpers = true

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
