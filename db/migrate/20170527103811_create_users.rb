class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :email
      t.boolean :admin
      t.boolean :allow_join_to_any
      t.timestamps
    end
  end
end
