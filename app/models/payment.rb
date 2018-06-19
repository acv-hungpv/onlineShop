class Payment < ApplicationRecord
  has_many :items
  
  default_scope { order(created_at: :desc)}
end