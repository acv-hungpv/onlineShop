require 'rails_helper'

feature "User logs in and logs out" do
  scenario "with correct details" do
    create(:user, email: "someone@example.come", name: "someone")
    visit "/"
    click_link "Log in"
    expect(current_path).to eq(login_path)
    fill_in "Email", with: "someone@example.come"
    fill_in "Password", with: "password"
    click_button "Log in"
    expect(page).to have_content "you have successfully logged in"
    expect(current_path).to eq products_path

    click_link "Log out"

    expect(current_path).to eq "/"
    expect(page).to have_content "you have logged out"
  end

  scenario "user cannot login" do
    create(:user, email: "someone@example.come", name: "someone")
    visit "/"
    click_link "Log in"
    expect(current_path).to eq(login_path)
    fill_in "Email", with: "someone@example.come"
    fill_in "Password", with: "wrongpassword"
    click_button "Log in"
    expect(page).not_to have_content "you have successfully logged in"
    expect(current_path).to eq login_path
  end
end