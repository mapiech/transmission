Sidekiq.configure_server do |config|
  config.redis = {
      url: YAML.load(File.read(File.join(Rails.root, 'config', 'redis.yml')))[Rails.env]['redis_jobs_url']
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
      url: YAML.load(File.read(File.join(Rails.root, 'config', 'redis.yml')))[Rails.env]['redis_jobs_url']
  }
end



Sidekiq::Extensions.enable_delay!