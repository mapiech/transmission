class AddColumnsToVideoTransmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :video_transmissions, :refresh_token, :string
    add_column :video_transmissions, :stream_id, :string
    add_column :video_transmissions, :stream_name, :string
  end
end
