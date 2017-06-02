module AsteriskWrapper

  class Sync

    include Ami
    include Ari
    include Cache
    include PhoneNumberParser

    attr_accessor :event, :data



    def initialize(event, data)
      self.event = event
      self.data = SafeParser.new(data).safe_load
    end

    def self.process(event, data)
      self.new(event, data).process
    end

    def process
      self.send "on_#{event.underscore}"
    end

    def on_confbridge_join

      cache.pipelined do
        cache.set "#{caller_id}-channel", channel
        cache.set "#{caller_id}-confbridge", bridge_name
        cache.set channel_id, caller_id
      end

      ActionCable.server.broadcast "update-#{bridge_name}", channel_object.attributes.merge(action: 'create')

      if channel_object.user.admin
        cache.set "#{bridge_name}-admin", caller_id
        cache.set "#{bridge_name}-unmuted", caller_id
      end

    end

    def on_bridge_leave

      ActionCable.server.broadcast "update-#{bridge_name}", channel_object.attributes.merge(action: 'destroy')

      if cache.get("#{bridge_name}-unmuted") == caller_id
        Channel.bridge_admin(bridge_name).try(:unmute)
      end

      cache.pipelined do
        cache.del "#{caller_id}-channel"
        cache.del "#{caller_id}-confbridge"
        cache.del "#{caller_id}-digit"

        (1..4).to_a.each do |loop_digit|
          cache.del("#{caller_id}-#{digit}")
        end

        cache.del channel_id
      end



    end

    def on_dtmf_begin

      if digit == 9

        cache.temporarily_set("#{caller_id}-9", true, 3)

      elsif digit == 0

        (1..4).to_a.each do |loop_digit|
          if cache.get("#{caller_id}-#{digit}").present?
            cache.temporarily_set("#{caller_id}-#{digit}", 'cancel', 5)
          end
        end
        ActionCable.server.broadcast "update-#{channel_object.bridge_name}", channel_object.comment_attributes(digit).merge(action: 'comment', comment_action: 'destroy')


      else

        if cache.get("#{caller_id}-9").present?
          cache.temporarily_set("#{caller_id}-count", digit, 60*60*3)
          cache.del "#{caller_id}-9"
          ActionCable.server.broadcast "update-#{channel_object.bridge_name}", channel_object.users_count_attributes.merge(action: 'update_count')
        elsif (1..4).to_a.include?(digit)
          cache.temporarily_set("#{caller_id}-#{digit}", digit, 15)
          if channel_object.phone_key_map_for_digit?(digit)
            ActionCable.server.broadcast "update-#{channel_object.bridge_name}", channel_object.comment_attributes(digit).merge(action: 'comment', comment_action: 'create')
          end
        end

      end

    end

    def on_confbridge_unmute
      cache.set "#{bridge_name}-unmuted", caller_id
      ActionCable.server.broadcast "update-#{channel_object.bridge_name}", channel_object.unmuted_attributes.merge(action: 'unmuted')
    end

    def channel_object(reload = false)
      unless reload
        @channel_object ||= Channel.new(caller_id)
      else
        @channel_object = Channel.new(caller_id)
      end
    end

    def bridge_name
      @bridge_name ||= data['BridgeName']
    end

    def channel
      @channel ||= data['Channel']
    end

    def channel_id
      @channel_id ||= data['Uniqueid']
    end

    def digit
      @digit ||= data['Digit'].to_i
    end

    def caller_id
      @caller_id ||= internal? ? data['CallerIDNum'] : parse_caller_id(data['CallerIDNum'])
    end

    def exten_id
      @exten_id ||= internal? ? data['Exten'] : parse_exten_id(data['CallerIDNum'])
    end

    def internal?
      data['CallerIDNum'].size < 9
    end





  end

end