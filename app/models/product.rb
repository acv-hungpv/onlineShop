class Product < ApplicationRecord
  has_many :product_categories
  has_many :categories, through: :product_categories
  has_one :item, dependent: :destroy

  validates :name, :description, :image, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  default_scope { order(created_at: :desc) }
end