class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :email, null: false, default: ""
      t.boolean :admin, null: false, default: false
      t.boolean :allow_join_to_any, null: false, default: false
      t.timestamps
    end
  end
end
