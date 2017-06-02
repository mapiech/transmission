class Congregation::KickController < Congregation::BaseController

  before_action :verify_channel, only: [ :kick ]
  before_action :verify_bridge, only: [ :kick_all ]

  def kick
    @channel.kick
    render plain: 'kick'
  end

  def kick_all
    AsteriskWrapper::Channel.kick_all(params[:bridge_name])
    render plain: 'kick_all'
  end

end
