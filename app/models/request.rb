class Request < ApplicationRecord
  STATUS = %w(pending accept decline)

  belongs_to :user
  belongs_to :listing

  validates :status, inclusion: { in: STATUS }
end

# input :thing, collection: Request::STATUS
