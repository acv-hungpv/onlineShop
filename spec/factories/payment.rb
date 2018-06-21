FactoryBot.define do  
  factory :payment do 
    phone_ship "01683853169"
    name_ship "Hung"
    address_ship "Tp.HCM"
    response ({ 'PayerID' => 'i049290jfsjf' })
  end
end