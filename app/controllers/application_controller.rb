class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :ok

  def ok
    render text: params.to_s and return
  end
  
end
