require 'rails_helper'

feature "User registers" do
  scenario "with valid details" do
    visit "/"
    click_link "sign up for the app"
    expect(current_path).to eq(signup_path)
    fill_in "choose a name", with: "name"
    fill_in "Email", with: "test@gmail.com"
    fill_in "Phone", with: "01234567891"
    fill_in "Address", with: "HCM city"
    fill_in "Password", with: "password"
    fill_in "Confirm Passord", with: "password"
    click_button "Create my account"
    expect(current_path).to eq(products_path)
  end

  context "with invalid details" do
    before do
      visit signup_path
    end

    scenario "blank fields" do
      click_button "Create my account"
      expect(page).to have_content ["Password can't be blank", 
                                    "Name can't be blank", 
                                    "Email can't be blank", 
                                    "Email is invalid", 
                                    "Address can't be blank", 
                                    "Phone can't be blank", 
                                    "Phone is not a number", 
                                    "Phone is too short (minimum is 10 characters)"]
    end

    scenario "incorrect password confirmation" do
      fill_in "choose a name", with: "name"
      fill_in "Email", with: "test@gmail.com"
      fill_in "Phone", with: "01234567891"
      fill_in "Address", with: "HCM city"
      fill_in "Password", with: "password"
      fill_in "Confirm Passord", with: "wrongpassword"
      click_button "Create my account"
      expect(page).to have_content "Password confirmation doesn't match Password"
    end

    scenario "already registered email" do
      create(:user, email: "hung@example.com")
      fill_in "choose a name", with: "name"
      fill_in "Email", with: "hung@example.com"
      fill_in "Phone", with: "01234567891"
      fill_in "Address", with: "HCM city"
      fill_in "Password", with: "password"
      fill_in "Confirm Passord", with: "password"
      click_button "Create my account"
      expect(page).to have_content "Email has already been taken"
    end
  end
end