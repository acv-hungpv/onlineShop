class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.references :item, index: true
      t.timestamps
    end
  end
end
