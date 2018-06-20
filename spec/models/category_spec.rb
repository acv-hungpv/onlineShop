require 'rails_helper'
RSpec.describe Category, type: :model do 
  context "Validate" do
    it { should validate_uniqueness_of(:name) }
  end

  context "Association" do
    it { should have_many(:product_categories) }
    it { should have_many(:products).through(:product_categories) }
  end

  context "Custom validate" do 
    let!(:category1) { create(:category, name:"category1") }
    let!(:category2) { create(:category, name:"category2") }
    let!(:category3) { create(:category, name:"category3") }
    it "ordering" do 
      expect(Category.last).to eq category1
      expect(Category.first).to eq category3
      expect(Category.second).to eq category2
    end
  end
end