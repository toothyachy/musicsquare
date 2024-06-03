class User < ApplicationRecord
  has_many :listings
  has_many :requests

  has_many :queues, through: :listings, source: :requests
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_picture
end
