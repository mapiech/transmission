class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  protected

  def after_sign_in_path_for(resource)
    if resource.kind_of? Admin or resource == :admin
      admin_root_path
    elsif resource.kind_of? Congregation  or resource == :congregation
      congregation_transmission_path
    elsif resource.kind_of? User  or resource == :user
      public_transmission_path
    end
  end

  def after_sign_out_path_for(resource)
    if resource.kind_of? Admin or resource == :admin
      admin_root_path
    elsif resource.kind_of? Congregation  or resource == :congregation
      congregation_root_path
    elsif resource.kind_of? User  or resource == :user
      public_root_path
    end
  end

  def set_menu(menu_key)
    @menu = menu_key
  end

end
