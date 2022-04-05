require "rails_helper"

describe "Admin" do
  scenario "Admin access links", :admin do
    Setting["feature.sdg"] = true

    visit root_path
    click_link "Menu"

    expect(page).to have_link("Administration")
    expect(page).to have_link("Valuation")
    expect(page).to have_link("SDG content")
    expect(page).not_to have_link("Management")
    expect(page).not_to have_link("Moderation")
  end

  scenario "Admin sidebar navigation links", :admin do
    visit admin_root_path

    within "#side_menu" do
      expect(page).not_to have_link("Comments")
      expect(page).not_to have_link("Voting booths")
      expect(page).not_to have_link("Messages to users")
      expect(page).not_to have_link("Moderated content")
      expect(page).not_to have_link("Proposals dashboard")

      click_link "Profiles"

      expect(page).to have_link("Administrators")
      expect(page).to have_link("Users")
      expect(page).not_to have_link("Organisations")
      expect(page).not_to have_link("Officials")
      expect(page).not_to have_link("Moderators")
      expect(page).not_to have_link("Valuators")
      expect(page).not_to have_link("Managers")
      expect(page).not_to have_link("SDG Managers")

      click_link "Settings"

      expect(page).to have_link("Global settings")
      expect(page).to have_link("Custom images")
      expect(page).to have_link("Custom content blocks")
      expect(page).not_to have_link("Proposals topics")
      expect(page).not_to have_link("Manage geozones")
      expect(page).not_to have_link("Manage local census")
    end
  end
end
