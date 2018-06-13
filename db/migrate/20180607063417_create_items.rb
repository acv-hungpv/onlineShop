class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.integer :amounts, default: 1
      t.references :product, index: true
      t.references :user, index: true
      t.references :payment, index: true
      t.timestamps
    end
  end
end
