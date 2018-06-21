require 'rails_helper'

RSpec.describe User, type: :model do 
  context "Validate" do
    let!(:user){ create(:user) }
    it { should validate_presence_of(:email)}
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(5) }
    it { should validate_length_of(:name).is_at_most(30) }
    it { should validate_length_of(:email).is_at_most(255) }
    it { should validate_uniqueness_of(:email).case_insensitive}
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