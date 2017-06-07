require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Transmission
  class Application < Rails::Application

    config.load_defaults 5.1

    config.cache_store = :redis_store, YAML.load(File.read(File.join(Rails.root, 'config', 'redis.yml')))[Rails.env]['redis_cache_store_url'], { expires_in: 180.minutes }

    config.active_job.queue_adapter = :sidekiq

    config.action_mailer.default_url_options = {
        host: ENV['SMTP_HOST'], port: ENV['SMTP_PORT']
    }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
        address:              'smtp.gmail.com',
        port:                 587,
        domain:               'localhost',
        user_name:            ENV['SMTP_EMAIL'],
        password:             ENV['SMTP_PASSWORD'],
        authentication:       'plain',
        enable_starttls_auto: true
    }

    config.action_cable.url = ENV['ACTION_CABLE_URL']
    config.action_cable.allowed_request_origins = %w( http://localhost http://lvh.me http://lt.me http://t.me )

  end

end
