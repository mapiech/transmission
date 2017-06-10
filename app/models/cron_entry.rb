class CronEntry < ApplicationRecord

  belongs_to :cron_wrapper

  validates :action_label, :day_label, :hour_label, :minute_label, presence: true

  attr_accessor :boot_wait

  class << self

    def distance(cron_entry_1_time, cron_entry_2_time)
      if cron_entry_1_time > cron_entry_2_time
        cron_entry_2_time = cron_entry_2_time + 1.week
      end
      (cron_entry_2_time - cron_entry_1_time).to_i
    end

  end

  def get_day_name(key)
    {
        'monday' => 'Poniedziałek',
        'tuesday' => 'Wtorek',
        'wednesday' => 'Środa',
        'thursday' => 'Czwartek',
        'friday' => 'Piątek',
        'saturday' => 'Sobota',
        'sunday' => 'Niedziela'
    }[key]
  end

  def day_name
    get_day_name(day_label)
  end

  def get_day_index(key)
    {
        'monday' => 1,
        'tuesday' => 2,
        'wednesday' => 3,
        'thursday' => 4,
        'friday' => 5,
        'saturday' => 6,
        'sunday' => 0
    }[key]
  end

  def day_index
    get_day_index(day_label)
  end

  def action_name
    {
        'boot' => 'Ustaw Uruchomienie Komputera',
        'shutdown' => 'Wyłącz Komputer'
    }[action_label]
  end

  def bind_time
    (Time.current.in_time_zone('Warsaw').beginning_of_week(:sunday) + day_index.days).change(hour: hour_label.to_i, min: minute_label.to_i)
  end

  def boot_time
    bind_time + boot_wait
  end

  def boot_day_label
    boot_time.strftime("%A").downcase
  end

  def boot_hour_label
    boot_time.hour.to_s
  end

  def boot_minute_label
    boot_time.min.to_s
  end

end
