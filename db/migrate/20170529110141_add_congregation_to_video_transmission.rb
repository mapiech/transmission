class AddCongregationToVideoTransmission < ActiveRecord::Migration[5.1]
  def change
    add_column :video_transmissions, :congregation_id, :integer
  end
end
