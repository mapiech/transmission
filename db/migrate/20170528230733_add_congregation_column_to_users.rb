class AddCongregationColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :congregation_id, :integer
  end
end
