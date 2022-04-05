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
end
