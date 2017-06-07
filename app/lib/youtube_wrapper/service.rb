module YoutubeWrapper

  module Service

    include Client

    def service
      @service ||= create_service
    end

    def create_service
      new_service = YoutubeV3::YouTubeService.new
      new_service.authorization = client
      new_service
    end

  end

end