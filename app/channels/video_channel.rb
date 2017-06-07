class VideoChannel < ApplicationCable::Channel

  def subscribed
    stream_from "video-#{params[:congregation]}"
  end


end
