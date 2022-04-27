require "rails_helper"

describe "CKEditor" do
  context "When navigating back to editor page using browser history back" do
    scenario "display ckeditor unsaved contents", :admin do
      visit new_admin_newsletter_path
      fill_in_ckeditor "Email content", with: "This is an unsaved body"
      click_link "Go back"

      expect(page).to have_link "New newsletter"

      go_back

      expect(page).to have_ckeditor "Email content", with: "This is an unsaved body"
    end
  end
end
