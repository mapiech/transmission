module YoutubeWrapper

  class Stream

    include Service

    def self.create_stream(refresh_token)

      snippet = YoutubeV3::LiveStreamSnippet.new(title: 'My Stream')
      cdn = YoutubeV3::CdnSettings.new(format: '720p', ingestion_type: 'rtmp')
      content_details = YoutubeV3::LiveStreamContentDetails.new(isReusable: true)

      live_stream = YoutubeV3::LiveStream.new(
          snippet: snippet,
          cdn: cdn,
          content_details: content_details
      )

      Stream.new(refresh_token, new_stream: live_stream)
    end

    attr_accessor :refresh_token, :stream_object, :new_stream, :id

    def initialize(refresh_token, options = {})

      self.refresh_token = refresh_token

      if options[:new_stream]
        @stream_object = service.insert_live_stream('id,snippet,cdn,status,contentDetails', options[:new_stream])
      end

      @id = options[:id] if options[:id]

    end

    def id
      @id ||= stream_object.id
    end

    def stream_object
      @stream_object ||= service.list_live_streams('id,snippet,cdn,status,contentDetails', id: id).items[0]
    end

    def reload
      @stream_object = service.list_live_streams('id,snippet,cdn,status,contentDetails', id: id).items[0]
    end

    def name
      @name ||= stream_object.cdn.ingestion_info.stream_name
    end

    def status
      @status = stream_object.status.stream_status
    end

    def active?
      status == 'active'
    end

  end

end