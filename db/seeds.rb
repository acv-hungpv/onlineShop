# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require_relative 'webhoseio'

table = ['products', 'users', 'categories', 'product_categories','items','payments']
auto_inc_val = 1

Product.destroy_all
User.destroy_all
Category.destroy_all
ProductCategory.destroy_all
Item.destroy_all
Payment.destroy_all

table.each do |t|
  ApplicationRecord.connection.execute(
  "ALTER SEQUENCE #{t}_id_seq RESTART WITH #{auto_inc_val}"
  )
end

User.create(name: "admin", email:"phanvanhunglmlm@gmail.com", password: "password",
          phone: "01683853169",
          address:"497 Hoa Hao,P7,Q10,TP.HCM", admin: true)
User.create(name: "user", email:"hungphan@gmail.com", password: "password", 
          phone: "01683853169",
          address:"497 Hoa Hao,P7,Q10,TP.HCM", admin: false)


webhoseio = Webhoseio.new('344a242c-e0fc-4475-9b1d-6d1beb587589')
query_params = {
'q': "category:womens-clothing"
}
output = webhoseio.query('productFilter', query_params)
numOutput = output['products'].count
category_names  = []
for i in 0..numOutput-1
  if  output['products'][i] != nil
    category_names += output['products'][i]['categories']
  end 
end
category_names = category_names.uniq

category_names.each do |name_had_created|
  category_row = Category.create!(name: name_had_created)
  for i in 0..numOutput-1
    if  output['products'][i] != nil && output['products'][i]['images'][0] != nil
      output['products'][i]['categories'].each do |category|
        if category == name_had_created
          product = Product.create(name: output['products'][i]['name'],
                                   description: output['products'][i]['description'],
                                   url: output['products'][i]['url'],
                                   price: output['products'][i]['price'],
                                   currency: output['products'][i]['currency'],
                                   image: output['products'][i]['images'][0])
          category_row.products << product
        end
      end
    end
  end
end
