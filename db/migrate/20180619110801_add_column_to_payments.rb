class AddColumnToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :name_ship, :string
    add_column :payments, :phone_ship, :string
    add_column :payments, :address_ship, :text 
  end
end
