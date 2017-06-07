class CreateBroadcastUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :broadcast_users do |t|
      t.integer :user_id
      t.integer :broadcast_id
      t.timestamps
    end
  end
end
