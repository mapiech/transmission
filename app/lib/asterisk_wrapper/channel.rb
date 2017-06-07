module AsteriskWrapper

  class Channel

    include Draper::Decoratable

    include Cache
    extend  Cache

    include Ari
    extend Ari

    include Ami
    extend Ami

    attr_accessor :caller_id, :channel, :bridge_name, :digit, :users_count

    def self.initial_data(bridge_name)
      begin
        unmuted_channel_object = unmuted_channel(bridge_name)
        {
            users: list(bridge_name),
            unmuted: unmuted_channel_object.present? ? unmuted_channel_object.mute_action_attributes : nil
        }
      rescue
        nil
      end
    end

    def self.list(bridge_name)

      channels_caller_ids = []

      bridge = Base.new.ari.bridges.list.find { |b| b.name == bridge_name }

      if bridge
        cache.pipelined do
          bridge.channels.each_with_index do |channel_caller_id, index|
            channels_caller_ids[index] = cache.get(channel_caller_id)
          end
        end

        bridge.channels.each_with_index do |channel_caller_id, index|
          channels_caller_ids[index] = channels_caller_ids[index].value
        end

      end

      #if bridge
      #  channels_caller_ids = bridge.channels.inject([]){|results, channel_caller_id| results << cache.get(channel_caller_id)}
      #end

      if channels_caller_ids.present?
        channels_caller_ids.inject([]) { |channels, channel_caller_id|
          channels << Channel.new(channel_caller_id).attributes
        }
      else
        []
      end

    end

    def self.bridge_admin(bridge_name)
      admin_caller_id = cache.get("#{bridge_name}-admin")
      if admin_caller_id.present?
        Channel.new(admin_caller_id)
      end
    end

    def self.kick_all(bridge_name)
      ami.command("confbridge kick #{bridge_name} all")
    end

    def self.unmuted_channel(bridge_name)
      caller_id = cache.get "#{bridge_name}-unmuted"
      caller_id.present? ? Channel.new(caller_id) : nil
    end

    def initialize(caller_id)
      self.caller_id = caller_id
      self.load_data_from_cache
    end

    def load_data_from_cache
      cache.pipelined do
        @channel = cache.get "#{caller_id}-channel"
        @bridge_name = cache.get "#{caller_id}-confbridge"
        @users_count = cache.get "#{caller_id}-count"
      end
      @channel = @channel.value
      @bridge_name = @bridge_name.value
      @users_count = @users_count.value
    end

    def phone
      @phone ||= Phone.includes(:phone_key_maps).where(phone_number: caller_id).first
    end

    def phone_key_map_for_digit?(digit)
      phone_key_map = phone_key_map_for_digit(digit)
      phone_key_map && phone_key_map.full_name.present?
    end

    def phone_key_map_for_digit(digit)
      phone.phone_key_maps.where(digit: digit).first
    end

    def user
      @user ||= phone.user
    end

    def users_count
      (@users_count || 1).to_i
    end

    def bridge_admin
      Channel.bridge_admin(bridge_name)
    end

    def complex_mute
      mute
      play_dtmf 9
      bridge_admin.try(:unmute)
    end

    def complex_unmute
      bridge_admin.try(:mute)
      unmute
      play_dtmf 1
    end

    def mute
      if channel
        ami.command("confbridge mute #{bridge_name} #{channel}")
        cache.del "#{bridge_name}-unmuted"
      end
    end

    def unmute
      if channel
        ami.command("confbridge unmute #{bridge_name} #{channel}")
        cache.set "#{bridge_name}-unmuted", caller_id
      end
    end

    def kick
      ami.command("confbridge kick #{bridge_name} #{channel}")
    end

    def play_dtmf(dtmf_digit)
      ami.public_execute('PlayDTMF', 'Channel' => channel, 'Digit' => dtmf_digit.to_s)
    end

    def comment_attributes(digit)

      if digit > 0
        {
            digit: digit,
            comment_full_name: phone_key_map_for_digit(digit).full_name,
            user_id: user.id,
            caller_id: caller_id,
            admin: user.admin
        }
      else
        {
            user_id: user.id,
            caller_id: caller_id,
            admin: user.admin
        }
      end


    end

    def mute_action_attributes
      {
          user_id: user.id,
          caller_id: caller_id,
          admin: user.admin
      }
    end

    def users_count_attributes
      {
          user_id: user.id,
          users_count: users_count,
          users_count_text: decorate.users_count_text
      }
    end

    def attributes
      {
          user_id: user.id,
          channel: channel,
          caller_id: caller_id,
          full_name: user.full_name,
          admin: user.admin
      }.merge(users_count_attributes)
    end

  end

end