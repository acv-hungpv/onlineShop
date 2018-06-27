require 'rails_helper'
RSpec.describe Item, type: :model do 
  context "Validate" do
    it { should belong_to(:user) }
    it { should belong_to(:product) }
    it { should belong_to(:payment) }
  end
end