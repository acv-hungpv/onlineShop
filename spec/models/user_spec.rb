require 'rails_helper'

RSpec.describe User, type: :model do 
  context "Validate" do
    it { should validate_presence_of(:email)}
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:address) }
  end

  context "Association" do
    it { should have_many(:items)}
  end

  context "Custom validate" do
    let!(:user1){ create(:user,email: "HUNGPHan@gmail.com")}
    it "expect set email to lower case" do 
      expect(user1.email).to eq 'hungphan@gmail.com'
    end

  end

end