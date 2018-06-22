FactoryBot.define do  
  factory :category do 
    name  { [*('A'..'Z')].sample(8).join }
  end
end