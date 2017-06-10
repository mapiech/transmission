class CronEntryDecorator < ApplicationDecorator

  def time
    "#{object.day_name}, #{object.hour_label}:#{object.minute_label}"
  end

end
