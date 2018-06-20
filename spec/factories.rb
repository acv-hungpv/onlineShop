FactoryBot.define do
  factory :user do 
    name "HungPhan"
    email "phanvanhunglmlm@gmail.com"
    password "password"
    phone "01683853169"
    phone_ship "01683853169"
    address "497 Hoa Hao,P7,Q10,TP.HCM"
    address_ship "497 Hoa Hao,P7,Q10,TP.HCM"
    admin false
    name_ship "hung phan"
  end

  factory :product do 
    name "test"
    description "test description"
    price 10
    image "https://www.ever-pretty.com/media/catalog/product/cache/5/small_image/202x264/9df78eab33525d08d6e5fb8d27136e95/A/S/AS04032BK-L_6_1.jpg"
  end

  factory :category do 
    name "test category"
  end

  factory :payment do 
    response ({ 'PayerID' => 'i049290jfsjf' })
  end
  # category { create(:category) }
  # factory :category do
  #   title "category"
  # end 

end