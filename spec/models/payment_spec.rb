require 'rails_helper'
RSpec.describe Payment, type: :model do 
  context "Association" do
    it { should have_many(:items) }
  end

  context "Validate" do 
    it { should validate_presence_of(:name_ship) }
    it { should validate_presence_of(:phone_ship) }
    it { should validate_presence_of(:address_ship) }
  end

  context "Custom validate" do 
    let!(:payment1) { create(:payment) }
    let!(:payment2) { create(:payment) }
    let!(:payment3) { create(:payment) }
    
    it "ordering" do 
      expect(Payment.last).to eq payment1
      expect(Payment.first).to eq payment3
      expect(Payment.second).to eq payment2
    end
  end
end