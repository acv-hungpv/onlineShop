class Item < ApplicationRecord
  belongs_to :user
  belongs_to :product
  belongs_to :payment, optional: true
end