class VideoTransmission < ApplicationRecord

  belongs_to :congregation

  def create_stream!
    begin
      stream = YoutubeWrapper::Stream.create_stream(refresh_token)
      self.stream_id = stream.id
      self.stream_name = stream.name
      self.save
    rescue
      Airbrake.notify("Stream could not be created.")
    end
  end

  def stream
    YoutubeWrapper::Stream.new(refresh_token, id: stream_id)
  end

end
