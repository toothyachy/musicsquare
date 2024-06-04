class Availability < ApplicationRecord
  belongs_to :listing

  validates :date_range, :day, :start_time, :end_time, presence: true
end
