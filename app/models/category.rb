class Category < ApplicationRecord
  validates :name, uniqueness: true 
  
  has_many :product_categories
  has_many :products, through: :product_categories

  default_scope { order(created_at: :desc) }
end