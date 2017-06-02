class Asterisk::AccessController < Asterisk::BaseController

  def index
    render plain: AsteriskWrapper::Access.internal_phone_number_for_caller(params[:caller])
  end

end