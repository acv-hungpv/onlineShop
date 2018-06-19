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


  # category { create(:category) }
  # factory :category do
  #   title "category"
  # end 

end