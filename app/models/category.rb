class Category < ApplicationRecord
  validates_uniqueness_of :name
  has_many :product_categories
  has_many :products, through: :product_categories
end