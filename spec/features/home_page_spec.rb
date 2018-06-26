require 'rails_helper'

feature "Home page" do
  scenario "visit" do
    visit "/"
    expect(page).to have_content "Welcome to ShopOnline"
  end
end
