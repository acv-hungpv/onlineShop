FactoryBot.define do
  factory :item do 
    amounts 2
    ispayment false
    product { create(:product) }
    user { create(:user) }
    payment { create(:payment)}
  end
end