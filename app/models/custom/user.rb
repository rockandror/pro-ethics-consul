require_dependency Rails.root.join("app", "models", "user").to_s

class User < ApplicationRecord
  has_one :guest_information, dependent: :destroy
end
