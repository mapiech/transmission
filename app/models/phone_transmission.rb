class PhoneTransmission < ApplicationRecord

  belongs_to :congregation

  validates :internal_phone_number, presence: true, if: proc { |t| t.congregation.has_phone_transmission }
  validates :sip_phone_number, presence: true, if: proc { |t| t.congregation.has_phone_transmission }

end
