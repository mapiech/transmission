module YoutubeWrapper

  module Client

    def client
      begin
        @client ||= create_client(refresh_token)
      rescue Signet::AuthorizationError
        Congregation.where(has_video_transmission: true).each do |congregation|
          ActionCable.server.broadcast "video-#{congregation.id}", { action: 'connection_error' }
        end
        raise
      end
    end

    def create_client(refresh_token)
      new_client =  Signet::OAuth2::Client.new(
          authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
          token_credential_uri:  'https://accounts.google.com/o/oauth2/token',
          client_id: ENV['GOOGLE_CLIENT_ID'],
          client_secret: ENV['GOOGLE_CLIENT_SECRET'],
          scope: 'http://gdata.youtube.com userinfo.email userinfo.profile plus.me',
          redirect_uri: 'http://localhost:3000/auth/google_oauth2/callback',
          refresh_token: refresh_token
      )
      new_client.fetch_access_token!
      new_client
    end

  end

end