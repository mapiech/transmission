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

  protected

  def update_cron
    render
  end


end
