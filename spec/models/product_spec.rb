require 'rails_helper'
RSpec.describe Product, type: :model do 
  context "Association" do
    it { should have_many(:product_categories) }
    it { should have_many(:categories).through(:product_categories) }
    it { should have_one(:item).dependent(:destroy) }
  end

  context "Validate" do 
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:image) }
    it { should validate_numericality_of(:price).is_greater_than(0) } 
  end

  context "Custom validate" do 
    let!(:product1) { create(:product) }
    let!(:product2) { create(:product) }
    let!(:product3) { create(:product) }
    it "ordering " do 
      expect(Product.last).to eq product1
      expect(Product.first).to eq product3
      expect(Product.second).to eq product2
    end
  end
end