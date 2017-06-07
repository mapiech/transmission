module YoutubeWrapper

  class Broadcast

    include Service

    def self.create_broadcast(refresh_token)

      snippet = Google::Apis::YoutubeV3::LiveBroadcastSnippet.new(
          title: "Zebranie: #{Time.current.to_date.to_s(:db)}",
          scheduled_start_time: Time.now.in_time_zone('Warsaw').iso8601 # rails
      )

      status = Google::Apis::YoutubeV3::LiveBroadcastStatus.new(privacy_status: 'unlisted')

      live_broadcast = Google::Apis::YoutubeV3::LiveBroadcast.new(
          snippet: snippet,
          status: status
      )

      Broadcast.new(refresh_token, new_broadcast: live_broadcast)
    end

    attr_accessor :refresh_token, :broadcast_object, :new_broadcast, :id

    def initialize(refresh_token, options = {})

      self.refresh_token = refresh_token
      puts refresh_token
      if options[:new_broadcast]
        @broadcast_object = service.insert_live_broadcast('id,snippet,status,contentDetails', options[:new_broadcast])
      end

      @id = options[:id] if options[:id]

    end

    def id
      @id ||= broadcast_object.id
    end

    def broadcast_object(reload = false)
      unless reload
        @broadcast_object ||= service.list_live_broadcasts('id,snippet,status,contentDetails', id: id).items[0]
      else
        @broadcast_object = service.list_live_broadcasts('id,snippet,status,contentDetails', id: id).items[0]
      end
    end

    def title
      @title = broadcast_object.snippet.title
    end

    def status
      broadcast_object.status.life_cycle_status
    end

    def stream_id
      broadcast_object.content_details.bound_stream_id
    end

    def stream?
      stream_id.present?
    end

    def stream
      stream? ? Stream.new(refresh_token, id: stream_id) : nil
    end

    def status?(request_status)
      status == request_status
    end

    def bind_to_stream(stream_id)
      result = service.bind_live_broadcast(id,'id,snippet,status,contentDetails', stream_id: stream_id)
      @broadcast_object = result
    end

    def test!
      transition('testing')
    end

    def live!
      transition('live')
    end

    def transition(transition_status)
      result = service.transition_live_broadcast(transition_status, id,'id,snippet,status,contentDetails')
      @broadcast_object = result
    end

  end

end