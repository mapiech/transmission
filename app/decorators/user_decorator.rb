class UserDecorator < Draper::Decorator

  def video_users_count_text
    case object.get_count
      when 0 then 'nikt nie ogląda'
      when 1 then '1 osoba ogląda'
      when 2..4 then "#{object.get_count} osoby oglądają"
      else "#{object.get_count} osób ogląda"
    end
  end

end