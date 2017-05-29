class UpdateChannel < ApplicationCable::Channel

  def subscribed
    stream_from "update"
  end

end
