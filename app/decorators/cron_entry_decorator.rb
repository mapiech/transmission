class CronEntryDecorator < ApplicationDecorator

  def time
    "#{object.day_name}, #{object.hour_label.rjust(2, '0')}:#{object.minute_label.rjust(2, '0')}"
  end

  def boot_time
    "#{object.get_day_name(object.boot_day_label)}, #{object.boot_hour_label.rjust(2, '0')}:#{object.boot_minute_label.rjust(2, '0')}"
  end

end
