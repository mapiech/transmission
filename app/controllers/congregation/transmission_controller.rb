class Congregation::TransmissionController < Congregation::BaseController

  before_action -> { set_menu(:transmission) }

  def index
    render
  end

end
