module YoutubeWrapper

  class BroadcastGenerator

    include Service

    attr_accessor :congregation_id

    class << self
      def generate(congregation_id)
        new(congregation_id).generate
      end
    end

    def initialize(congregation_id)
      self.congregation_id = congregation_id
    end

    def congregation
      @congregation ||= Congregation.find(congregation_id)
    end

    def video_transmission
      @video_transmission ||= congregation.video_transmission
    end

    def refresh_token
      @refresh_token ||= video_transmission.refresh_token
    end

    def stream_id
      @stream_id ||= video_transmission.stream_id
    end

    def broadcast_service_id
      broadcast.broadcast_id
    end

    # Active Record
    def broadcast
      @broadcast ||= find_or_create_broadcast
    end

    # Youtube
    def broadcast_service
      @broadcast_service ||= Broadcast.new(refresh_token, id: broadcast_service_id)
    end

    def generate

      begin
        # only created
        if broadcast_service_id.blank?

          # we try so much as we can at first time

          # creating broadcast service
          @broadcast_service = Broadcast.create_broadcast(refresh_token)
          broadcast.bind_broadcast_service!(broadcast_service.id)

          # bind live stream to live broadcast
          broadcast_service.bind_to_stream(stream_id)

          if_active_stream do
            # transition to test
            broadcast_service.test!
          end

          next_loop

        else

          # if stream is not binded

          puts "stream binded: #{broadcast_service.stream?}"
          unless broadcast_service.stream?
            broadcast_service.bind_to_stream(stream_id)
          end

          current_broadcast_status = broadcast_service.status
          puts "broadcast status: #{current_broadcast_status}"
          # live status
          # stop generating
          if current_broadcast_status == 'live'
            broadcast.live!
            ActionCable.server.broadcast "video-#{congregation_id}", { action: 'live' }.merge(broadcast.data_attributes)

          else

            if_active_stream do

              if current_broadcast_status == 'testing'
                broadcast_service.live!
              else
                broadcast_service.test!
              end

            end

            next_loop

          end

        end
      rescue Exception => e
        puts e
        puts e.backtrace
        next_loop
      end
    end

      def next_loop(seconds = 25)
        BroadcastGenerator.delay_for(seconds.seconds, retry: false).generate(congregation_id)
      end

      def find_or_create_broadcast
        ::Broadcast.broadcast_for_congregation(congregation_id) or ::Broadcast.create(congregation_id: congregation_id, day_label: ::Broadcast.today_day_label, status: 'initializing')
      end

      def message_subscribed_users(message_type, message_content)
        ActionCable.server.broadcast "video-#{congregation_id}", { action: 'message', message_content: message_content, message_type: message_type}
      end

      def if_active_stream
        if broadcast_service.stream.active?
          yield
        else
          message_subscribed_users(:alert,  'Sprawdź, czy streaming w OBS jest włączony.')
        end
      end



  end

end