class CreateBroadcasts < ActiveRecord::Migration[5.1]
  def change
    create_table :broadcasts do |t|
      t.integer :congregation_id
      t.string :broadcast_id
      t.string :day_label
      t.string :status
      t.timestamps
    end
  end
end
