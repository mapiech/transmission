class CreatePhoneTransmissions < ActiveRecord::Migration[5.1]
  def change
    create_table :phone_transmissions do |t|
      t.integer :congregation_id
      t.string :internal_phone_number
      t.string :sip_phone_number
      t.timestamps
    end
  end
end
