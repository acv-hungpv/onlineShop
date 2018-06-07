class CreateProductCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :product_categories do |t|
      t.references :category, index: true
      t.references :product, index: true
    end
  end
end
