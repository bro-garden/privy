require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Privy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.middleware.use(Rack::Config) do |env|
      env['api.tilt.root'] = Rails.root.join 'app/views/api'
    end
    active_record_encryption = Rails.application.credentials.active_record
    config.active_record.encryption.primary_key = active_record_encryption.primary_key
    config.active_record.encryption.deterministic_key = active_record_encryption.deterministic_key
    config.active_record.encryption.key_derivation_salt = active_record_encryption.key_derivation_salt

    config.active_job.queue_adapter = :delayed_job

    Rails.application.routes.default_url_options[:host] = Rails.application.credentials.web_interface.url
  end
end
