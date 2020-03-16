class Broadcast < ApplicationRecord

  belongs_to :congregation
  has_many :broadcast_users, dependent: :delete_all
  has_many :users, through: :broadcast_users
  accepts_nested_attributes_for :users, allow_destroy: true


  before_validation :set_day_label, on: [ :create ]

  class << self

    def today_day_label
      Time.current.in_time_zone('Warsaw').to_date.to_s(:db)
    end

    def initial_data(congregation_id)
      broadcast = broadcast_for_congregation(congregation_id)
      if broadcast
        broadcast.data_attributes
      else
        nil
      end
    end

    def broadcast_for_congregation(congregation_id, validate_option = true)
      find_broadcast_with_status(congregation_id, validate_option) do
        Broadcast.where(congregation_id: congregation_id, day_label: today_day_label).where.not(status: 'complete').first
      end
    end

    def live_broadcast_for_congregation(congregation_id, validate_option = true)
      find_broadcast_with_status(congregation_id, validate_option) do
        Broadcast.where(congregation_id: congregation_id, day_label: today_day_label, status: 'live').first
      end
    end

    def find_broadcast_with_status(congregation_id, validate_option = true)
      broadcast = yield
      if validate_option && broadcast && broadcast.broadcast_id.present? && ((broadcast.created_at + 3.minutes) < Time.current )
        broadcast.validate_broadcast!
        broadcast = yield
      end
      broadcast
    end

  end

  def broadcast_service
    @broadcast_service ||= YoutubeWrapper::Broadcast.new(refresh_token, id: broadcast_id)
  end

  def refresh_token
    @refresh_token ||= congregation.video_transmission.refresh_token
  end

  def stream_name
    @stream_name ||= congregation.video_transmission.stream_name
  end

  def data_attributes
    users_data = users.inject([]) do |user_data, user|
      user_data << user.video_attributes
    end

    {
        broadcast_id: broadcast_id,
        status: status,
        users: users_data
    }
  end


  def bind_broadcast_service!(broadcast_service_id)
    self.broadcast_id = broadcast_service_id
    self.save!
  end

  def status?(request_status)
    status == request_status
  end

  def live
    self.status = 'live'
    self.user_ids = congregation.users.where(auto_invite_to_video: true).ids
  end

  def live!
    live
    self.save
  end

  def complete
    self.status = 'complete'
  end

  def complete!
    complete
    self.save
  end

  # auto switch broadcast from live to complete
  def validate_broadcast!

    # we can't check it each time when user open transmission page
    # it generates too many api calls

    broadcast_status = Rails.cache.fetch("broadcast_status_#{id}", expires_in: 3.hours) do
      broadcast_service.status
    end

    if broadcast_status == 'complete'
      complete!
    end

  end

  def user_has_access?(user_id)
    user_ids.include?(user_id)
  end

  protected

  def set_day_label
    self.day_label = Broadcast.today_day_label
  end

end
