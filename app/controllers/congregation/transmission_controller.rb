class Congregation::TransmissionController < Congregation::BaseController

  before_action -> { set_menu(:transmission) }

  def index
    begin
      if current_congregation.has_video_transmission
        @broadcast = Broadcast.broadcast_for_congregation(current_congregation.id)
      end
    rescue Signet::AuthorizationError
      @google_auth_error = true
    end
  end

end
