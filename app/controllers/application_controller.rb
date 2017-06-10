class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  layout :layout_by_resource

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

  def only_local_ips_or_admin!
    remote_ip = request.remote_ip
    if !(remote_ip.starts_with?('192.168') or remote_ip.starts_with?('127.0.0.1') or remote_ip == ENV['ADMIN_IP'])
      redirect_to public_root_path and return
    end
  end

  def layout_by_resource
    if devise_controller? && resource_name == :user
      'public'
    else
      'application'
    end
  end

  def set_menu(menu_key)
    @menu = menu_key
  end

end
