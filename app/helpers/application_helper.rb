module ApplicationHelper

  include OmniauthScopeHelper
  
  def default_root_path
    if request.path.starts_with?('/admin')
      admin_root_path
    elsif current_layout?('public') or request.path.starts_with?('/public')
      public_root_path
    else
      current_congregation ? congregation_transmission_path : root_path
    end
  end

  def view_sign_out_path
    if request.path.starts_with?('/admin')
      destroy_admin_session_path
    elsif current_layout?('public') or request.path.starts_with?('/public')
      destroy_user_session_path
    else
      destroy_congregation_session_path
    end
  end

  def phone_number(p)
    "#{p[0]}#{p[1]} #{p[2]}#{p[3]}#{p[4]} #{p[5]}#{p[6]} #{p[7]}#{p[8]}"
  end

  def current_layout
    layout = controller.class.send(:_layout)

    if layout.respond_to? :call
      layout = layout.call
    end

    if layout.nil?
      'public'
    elsif layout.instance_of? String or layout.instance_of? Symbol
      layout
    else
      File.basename(layout.identifier).split('.').first
    end
  end

  def current_layout?(name)
    current_layout == name
  end

end
