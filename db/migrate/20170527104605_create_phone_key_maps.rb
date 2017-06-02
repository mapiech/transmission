class CreatePhoneKeyMaps < ActiveRecord::Migration[5.1]
  def change
    create_table :phone_key_maps do |t|
      t.integer :phone_id
      t.integer :digit
      t.string  :full_name, null: false, default: ""
    end
  end
end
