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

  end
end
