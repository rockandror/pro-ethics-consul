require "rails_helper"

describe "Sign in links", :disable_sign_in_links do
  context "Page using guest users" do
    scenario "Does not render for guest users" do
      visit polls_path

      expect(page).not_to have_link "Sign in"
      expect(page).not_to have_link "Register"
      expect(page).not_to have_link "My content"
      expect(page).not_to have_link "My account"
    end

    scenario "Does render for identified users" do
      login_as(create(:administrator).user)

      visit polls_path

      expect(page).to have_link "Menu"
      expect(page).to have_link "My content"
      expect(page).to have_link "My account"
    end
  end

  context "Page not using guest users" do
    scenario "Does not render for anonymous users" do
      visit root_path

      expect(page).not_to have_link "Sign in"
      expect(page).not_to have_link "Register"
      expect(page).not_to have_link "My content"
      expect(page).not_to have_link "My account"
    end

    scenario "Does render for identified users" do
      login_as(create(:user))

      visit root_path

      expect(page).to have_link "My content"
      expect(page).to have_link "My account"
    end
  end
end
