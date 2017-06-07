class AddAutoInviteToVideoTransmission < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :auto_invite_to_video, :boolean, default: false
  end
end
