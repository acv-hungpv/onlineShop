class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.text :name
      t.text :description
      t.text :url
      t.float :price
      t.string :currency
      t.text :images
      t.timestamps
    end
  end
end
