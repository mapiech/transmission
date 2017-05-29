class CreateVideoTransmissions < ActiveRecord::Migration[5.1]
  def change
    create_table :video_transmissions do |t|

      t.timestamps
    end
  end
end
