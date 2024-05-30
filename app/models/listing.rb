class Listing < ApplicationRecord
  belongs_to :user
  validates :name, presence: true

  validates :looking_for, inclusion: { in: %w(vocals keyboardist guitarist bassist drummer), message: "%{value} is not a valid musician" }
end
