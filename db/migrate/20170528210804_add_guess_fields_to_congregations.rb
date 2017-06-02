class AddGuessFieldsToCongregations < ActiveRecord::Migration[5.1]
  def change
    add_column :congregations, :default_ip, :integer
    add_column :congregations, :default_day, :integer
    add_column :congregations, :default_weekend_time, :float
  end
end
