require 'rails_helper'

describe 'products feature', type: :feature do
  it 'Admin can edit a product' do
    product = create(:product)
    visit "products/#{ product.id }/edit"
    expect(page).to have_button 'Update Product'
    fill_in 'Name', with: 'edit name'
    click_on 'Update Product'
    product.reload
    expect(product.name).to eq 'edit name'
  end
end