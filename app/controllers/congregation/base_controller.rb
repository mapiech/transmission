class Congregation::BaseController < ApplicationController

  before_action :authenticate_congregation!

  layout 'application'

  protected

  def verify_bridge
    if current_congregation.internal_phone_number != params[:bridge_name]
      render_no_access_to_resource
    end
  end

  def verify_channel
    @channel = AsteriskWrapper::Channel.new(params[:caller_id])
    if !(@channel && @channel.bridge_name == current_congregation.internal_phone_number)
      render_no_access_to_resource
    end
  end

  def render_no_access_to_resource
    render status: 401, plain: 'error'
  end

end
