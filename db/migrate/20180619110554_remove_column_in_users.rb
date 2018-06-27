class RemoveColumnInUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :phone_ship, :string
    remove_column :users, :address_ship, :text
    remove_column :users, :name_ship, :string
  end
end
