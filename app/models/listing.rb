class Listing < ApplicationRecord
  MUSICIANS = %w(vocals keyboardist guitarist bassist drummer)
  belongs_to :user
  has_many :availabilities

  validates :name, presence: true
  validates :looking_for, inclusion: { in: MUSICIANS, message: "%{value} is not a valid musician" }
end
