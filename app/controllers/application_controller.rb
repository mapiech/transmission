class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :ok
  protected

  def ok
  #  render plain: 'ok'
  end

  def after_sign_in_path_for(resource)
    if resource.kind_of? Admin or resource == :admin
      admin_root_path
    elsif resource.kind_of? Congregation  or resource == :congregation
      congregation_transmission_path
    end

  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def set_menu(menu_key)
    @menu = menu_key
  end

end
