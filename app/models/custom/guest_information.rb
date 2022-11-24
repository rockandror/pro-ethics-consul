class GuestInformation < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true, uniqueness: true
  validates :email, presence: true
end
