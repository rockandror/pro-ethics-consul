require "rails_helper"

describe "Guest informations" do
  describe "From legislation draft versions page" do
    let(:draft_version) { create(:legislation_draft_version, :published) }

    scenario "Show success notice when contact data is persisted" do
      visit legislation_process_draft_version_path(draft_version.process, draft_version)

      fill_in "Name", with: "Tom Cruise"
      fill_in "Email", with: "tom@cruise.com"
      click_button "Update"

      expect(page).to have_content "Your contact data was saved successfully!"
      expect(page).to have_field "Email", with: "tom@cruise.com"
      expect(page).to have_field "Name", with: "Tom Cruise"
    end

    scenario "Shows errors when there is validation errors" do
      visit legislation_process_draft_version_path(draft_version.process, draft_version)

      fill_in "Name", with: "Tom Cruise"
      click_button "Update"

      expect(page).to have_content "can't be blank"
    end
  end
end
