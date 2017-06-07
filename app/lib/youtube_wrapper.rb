require 'signet/oauth_2/client'
require 'google/apis/youtube_v3'


module YoutubeWrapper

  YoutubeV3 = Google::Apis::YoutubeV3

end

%w{
  client
  service
  stream
  broadcast
}.each { |f| require "youtube_wrapper/#{f}"}


