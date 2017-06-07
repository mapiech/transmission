class Public::TransmissionController < Public::BaseController

  def index
    @broadcast = current_user.find_broadcast
  end

end
