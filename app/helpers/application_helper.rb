module ApplicationHelper

  def default_root_path
    if request.path.starts_with?('/admin')
      admin_root_path
    else
      current_congregation ? congregation_transmission_path : root_path
    end
  end

  def phone_number(p)
    "#{p[0]}#{p[1]} #{p[2]}#{p[3]}#{p[4]} #{p[5]}#{p[6]} #{p[7]}#{p[8]}"
  end

end
