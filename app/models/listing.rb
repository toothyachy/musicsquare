class Listing < ApplicationRecord
  MUSICIANS = %w(vocals keyboardist guitarist bassist drummer)
  belongs_to :user
  has_many :requests
  has_many :availabilities, dependent: :destroy
  accepts_nested_attributes_for :availabilities

  validates :name, presence: true
  validates :looking_for, inclusion: { in: MUSICIANS, message: "%{value} is not a valid musician" }

  has_one_attached :sound_clip
  has_many_attached :images
end
