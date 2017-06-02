module AsteriskWrapper
  module Cache
    @@cache = nil

    def cache
      @@cache ||= Redis.new(host: '127.0.0.1', port: 6379, db: 3)

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