module ApplicationHelper

  def default_root_path
    if request.path.starts_with?('/admin')
      admin_root_path
    else
      current_congregation ? congregation_transmission_path : root_path
    end

  end

end
