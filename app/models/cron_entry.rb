class CronEntry < ApplicationRecord

  belongs_to :cron_wrapper

  validates :action_label, :day_label, :hour_label, :minute_label, presence: true


  def day_name
    {
        'monday' => 'Poniedziałek',
        'tuesday' => 'Wtorek',
        'wednesday' => 'Środa',
        'thursday' => 'Czwartek',
        'friday' => 'Piątek',
        'saturday' => 'Sobota',
        'sunday' => 'Niedziela'
    }[day_label]
  end

  def action_name
    {
        'boot' => 'Uruchom Komputer',
        'shutdown' => 'Wyłącz Komputer'
    }[action_label]
  end

end
