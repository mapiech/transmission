class UpdateChannel < ApplicationCable::Channel

  def subscribed
    stream_from "update-#{params[:transmission]}"
  end

end
