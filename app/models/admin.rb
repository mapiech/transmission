class Admin < ApplicationRecord

  devise :database_authenticatable, :registerable, :validatable

end
