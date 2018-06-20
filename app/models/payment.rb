class Payment < ApplicationRecord
  has_many :items
  
  validates :phone_ship, :name_ship, :address_ship, presence: true
  default_scope { order(created_at: :desc) }
end