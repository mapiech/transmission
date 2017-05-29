class DeviseCreateCongregations < ActiveRecord::Migration[5.1]
  def change
    create_table :congregations do |t|

      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      t.string :name

      t.boolean :has_phone_transmission
      t.boolean :has_video_transmission

      t.timestamps null: false
    end

    add_index :congregations, :email, unique: true

  end
end
