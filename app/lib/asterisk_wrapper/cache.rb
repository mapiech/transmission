module AsteriskWrapper
  module Cache
    @@cache = nil

    def cache
      @@cache ||= Redis.new(url: YAML.load(File.read(File.join(Rails.root, 'config', 'redis.yml')))[Rails.env]['redis_asterisk_cache_store_url'])

      def @@cache.temporarily_set(key, value, seconds)
        @@cache.multi do
          set(key, value)
          expire(key, seconds)
        end
      end

      @@cache
    end



  end
end