class BroadcastUser < ApplicationRecord

  belongs_to :broadcast
  belongs_to :user

  after_create :send_notification

  protected

  def send_notification
    UserMailer.broadcast_info(broadcast_id: broadcast_id, user_id: user_id).deliver_later
  end

end
