class Product < ApplicationRecord
  has_many :product_categories
  has_many :categories, through: :product_categories
  has_one :item, dependent: :destroy

  default_scope { order(created_at: :desc)}
end