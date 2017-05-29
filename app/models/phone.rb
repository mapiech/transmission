class Phone < ApplicationRecord

  belongs_to :user
  has_many :phone_key_maps

  accepts_nested_attributes_for :phone_key_maps

  validates :phone_number, presence: true, uniqueness: true

end
