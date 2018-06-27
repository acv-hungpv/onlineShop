FactoryBot.define do
  factory :user do 
    name "HungPhan"
    email { [*('A'..'Z')].sample(8).join + "@gmail.com" }
    password "password"
    password_confirmation "password"
    phone "01683853169"
    address "497 Hoa Hao,P7,Q10,TP.HCM"
    admin false
  end
end