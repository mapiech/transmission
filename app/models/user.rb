class User < ApplicationRecord

  belongs_to :congregation
  has_one :phone

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

end
