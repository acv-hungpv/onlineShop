class Payment < ApplicationRecord
  has_many :items
  
  validates :name_ship, :address_ship, presence: true
  validates :phone_ship,:presence => true,
                 :numericality => true,
                 :length => { :minimum => 10, :maximum => 15 }
                 
  default_scope { order(created_at: :desc) }
end