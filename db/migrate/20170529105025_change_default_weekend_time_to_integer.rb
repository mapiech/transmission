class ChangeDefaultWeekendTimeToInteger < ActiveRecord::Migration[5.1]
  def change
    change_column :congregations, :default_weekend_time, :integer
  end
end
