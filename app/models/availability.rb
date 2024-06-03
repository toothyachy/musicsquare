class Availability < ApplicationRecord
  belongs_to :listing

  validates :listing, presence: true
end
