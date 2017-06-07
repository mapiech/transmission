class User < ApplicationRecord

  devise :database_authenticatable

  include AsteriskWrapper::Cache

  def encrypted_password
    'fake encrypted password'
  end

  belongs_to :congregation
  has_one :phone

  has_many :broadcast_users
  has_many :broadcasts

  scope :with_email, ->() { where.not(email: '') }

  accepts_nested_attributes_for :phone

  validates :full_name, presence: true
  validates :email, format: { allow_blank: true, with: Devise.email_regexp }

  def prepare
    unless phone.present?
      self.build_phone
      for i in 1..4 do
        self.phone.phone_key_maps.build(
            digit: i
        )
      end
    end
  end

  def congregation_can_remove_user?
    !admin && !allow_join_to_any
  end

  def find_broadcast
    broadcast = Broadcast.live_broadcast_for_congregation(congregation_id)
    (broadcast && broadcast.user_has_access?(id)) ? broadcast : nil
  end

  # video transmission
  def set_count(count)
    cache.temporarily_set("#{id}-count", count, 60*60*3)
    ActionCable.server.broadcast "video-#{congregation_id}", { action: 'count' }.merge(video_attributes)
  end

  # video transmission
  def get_count
    cache.get("#{id}-count").to_i
  end

  def video_attributes
    { user_id: id, full_name: full_name, users_count: get_count, users_count_text: decorate.video_users_count_text }
  end

end
