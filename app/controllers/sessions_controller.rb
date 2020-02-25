class SessionsController < Devise::SessionsController

  #prepend_before_action :only_local_ips_or_admin!

  protected

  def only_local_ips_or_admin!
    remote_ip = request.remote_ip
    if resource_name != :user and !(remote_ip.starts_with?('192.168') or remote_ip.starts_with?('127.0.0.1') or remote_ip == ENV['ADMIN_IP'])
      redirect_to public_root_path and return
    end
  end

end
