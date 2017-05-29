class CreatePhones < ActiveRecord::Migration[5.1]
  def change
    create_table :phones do |t|
      t.integer :user_id
      t.string :phone_number, unique: true
      t.timestamps
    end
  end
end
