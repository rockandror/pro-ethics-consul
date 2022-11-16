require "rails_helper"

describe "Legislation Draft Versions" do
  context "Annotations" do
    let(:draft_version) { create(:legislation_draft_version, :published) }

    scenario "Visit as anonymous shows annotation form and allow to add annotations and replies" do
      visit legislation_process_draft_version_path(draft_version.process, draft_version)
      find(:css, ".legislation-annotatable").double_click
      find(:css, ".annotator-adder button").click

      expect(page).to have_field "Comment"

      fill_in "Comment", with: "this is my annotation"
      click_button "Publish Comment"

      expect(page).to have_css ".annotator-hl"

      first(:css, ".annotator-hl").click

      expect(page).to have_content "this is my annotation"

      click_link "Publish Comment"

      expect(page).to have_field "Leave your comment"

      fill_in "Leave your comment", with: "this is a comment on my previous annotation"
      click_button "Publish comment"

      expect(page).to have_css ".annotator-hl"

      first(:css, ".annotator-hl").click

      expect(page).to have_content "this is a comment on my previous annotation"
    end
  end
end
