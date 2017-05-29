class AddGuessFieldsToCongregations < ActiveRecord::Migration[5.1]
  def change
    add_column :congregations, :default_ip, :string
    add_column :congregations, :default_day, :string
    add_column :congregations, :default_weekend_time, :float
  end
end
