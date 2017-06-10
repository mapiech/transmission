require 'erb'

class CronWrapper < ApplicationRecord

  has_many :cron_entries, inverse_of: :cron_wrapper
  accepts_nested_attributes_for :cron_entries, reject_if: :all_blank, allow_destroy: true

  after_save :update_cron

  def get_binding
    binding
  end

  def render
    renderer = ERB.new(File.read(File.join(Rails.root, 'lib/cron_wrappers', 'schedule.rb.erb')))
    File.open(File.join(Rails.root, '../schedule.rb'), 'w') { |file| file.write(renderer.result(self.get_binding)) }
    `cd #{Rails.root} && whenever --load-file ../schedule.rb --update-cron`
  end

  def sorted_cron_entries
    cron_entries.to_a.sort_by{|c| [c.day_index, c.hour_label.to_i, c.minute_label.to_i]}
  end

  def cron_entries_with_boot
    db_cron_entries = sorted_cron_entries

    full_cron_entries = db_cron_entries.each_with_index.inject([]) do |full_cron_entries, (cron_entry, i)|


      # boot cron
      related_cron_entry = db_cron_entries[i+1].present? ? db_cron_entries[i+1] : db_cron_entries[0]

      executed_time = cron_entry.bind_time - 10.minutes

      full_cron_entries << CronEntry.new(
          action_label: 'boot',
          day_label: executed_time.strftime("%A").downcase,
          hour_label: executed_time.hour.to_s,
          minute_label: executed_time.min.to_s,
          boot_wait: CronEntry.distance(executed_time, related_cron_entry.bind_time - 4.hours)
      )

      full_cron_entries << cron_entry

      full_cron_entries
    end

  end

  protected

  def update_cron
    render
  end


end
