class Asterisk::SyncController < Asterisk::BaseController

  def index
    AsteriskWrapper::Sync.process(params[:event], params[:data])
    render plain: 'sync: ok'
  end

  def status
    render plain: 'status'
  end

end
