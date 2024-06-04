class Request < ApplicationRecord
  STATUS = %w(pending accept decline)

  belongs_to :user
  belongs_to :listing

  validates :status, inclusion: { in: STATUS }
  validates :request_date, :request_time, presence: true

  def display_time
    request_time[11..15]
  end
end

# input :thing, collection: Request::STATUS
