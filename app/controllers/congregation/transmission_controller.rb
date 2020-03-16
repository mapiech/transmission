class Congregation::TransmissionController < Congregation::BaseController

  skip_before_action :authenticate_congregation!, only: [ :comments ]
  before_action -> { set_menu(:transmission) }

  def index
    begin
      if current_congregation.has_video_transmission
        @broadcast = Broadcast.broadcast_for_congregation(current_congregation.id)
      end
    rescue Signet::AuthorizationError
      @google_auth_error = true
    rescue
      @video_transmission_not_available = true
    end
  end

  def comments
    @congregation = Congregation.find(params[:congregation_id])
  end

end
