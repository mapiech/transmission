class ChangeDefaultDayToInteger < ActiveRecord::Migration[5.1]

  def up
    change_column :congregations, :default_day, :integer
  end

  def down
    change_column :congregations, :default_day, :string
  end

end
