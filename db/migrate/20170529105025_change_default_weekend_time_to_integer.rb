class ChangeDefaultWeekendTimeToInteger < ActiveRecord::Migration[5.1]

  def up
    change_column :congregations, :default_weekend_time, :integer
  end

  def down
    change_column :congregations, :default_weekend_time, :string
  end

end
