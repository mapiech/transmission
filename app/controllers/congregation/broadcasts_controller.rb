class Congregation::BroadcastsController < Congregation::BaseController

  def create
    YoutubeWrapper::BroadcastGenerator.generate(current_congregation.id)
    render plain: 'start'
  end

  def edit
    @broadcast = Broadcast.broadcast_for_congregation(current_congregation.id, false)
    render partial: 'form', layout: false
  end

  def update
    @broadcast = Broadcast.broadcast_for_congregation(current_congregation.id, false)
    if @broadcast.update(broadcast_attributes)
      render json: @broadcast.data_attributes
    else
      render json: @broadcast.data_attributes
    end
  end

  protected

  def broadcast_attributes
    params.require(:broadcast).permit(:id, user_ids: [])
  end

end
