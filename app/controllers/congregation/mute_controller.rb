class Congregation::MuteController < Congregation::BaseController

  before_action :verify_channel

  def mute
    @channel.complex_mute
    render plain: 'mute'
  end

  def unmute
    @channel.complex_unmute
    render plain: 'mute'
  end

end
