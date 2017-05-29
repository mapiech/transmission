class Congregation < ApplicationRecord

  devise :database_authenticatable, :registerable, :validatable, password_length: 4..6

  has_many :users, dependent: :destroy
  has_one :phone_transmission, dependent: :destroy
  has_one :video_transmission, dependent: :destroy

  accepts_nested_attributes_for :phone_transmission
  accepts_nested_attributes_for :video_transmission

  validates :name, presence: true

  before_validation :generate_email, on: [ :create ]

  class << self

    def guess_to_sign_in(current_ip)

      time_now = Time.current.in_time_zone('Warsaw')
      time_now_index = time_now.hour.to_f + time_now.min/60

      congregations = where(default_ip: current_ip).to_a

      if time_now.on_weekend?
        congregations.min{|first, second| (first.default_weekend_time - time_now_index).abs <=> (second.default_weekend_time - time_now_index).abs }
      else
        congregations.min{|first, second| (first.default_day.to_i - time_now.wday).abs <=> (second.default_day.to_i - time_now.wday).abs }
      end
    end

  end

  def prepare
    self.build_phone_transmission unless phone_transmission
    self.build_video_transmission unless video_transmission
  end

  protected

  def generate_email
    self.email = "#{name.parameterize}-#{SecureRandom.hex(1)}@t.me"
  end

end
