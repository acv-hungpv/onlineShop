class AddFieldsToUsersV2 < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :phone_ship, :string
    add_column :users, :address_ship, :text
    add_column :users, :name_ship, :string
  end
end
