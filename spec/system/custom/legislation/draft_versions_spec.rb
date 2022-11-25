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

    scenario "Visit as anonymous allow to vote annotation comments" do
      visit legislation_process_draft_version_path(draft_version.process, draft_version)
      find(:css, ".legislation-annotatable").double_click
      find(:css, ".annotator-adder button").click

      expect(page).to have_field "Comment"

      fill_in "Comment", with: "this is my annotation"
      click_button "Publish Comment"

      expect(page).to have_css ".annotator-hl"

      first(:css, ".annotator-hl").click

      expect(page).to have_content "this is my annotation"

      first(:css, ".annotator-hl").click

      expect(page).to have_content "No votes"

      click_button "I agree"

      expect(page).to have_content "1 vote"
    end
  end

  context "See draft text page" do
    let(:process) { create(:legislation_process) }

    let!(:original) do
      create(:legislation_draft_version, process: process, title: "Original",
                                         body: "Original version", status: "published")
    end

    scenario "show help gif" do
      visit legislation_process_draft_version_path(process, original)

      click_button text: "How can I comment this document?"

      expect(page).to have_content "Select the text you want to comment and press the button with the pencil"
      expect(page).not_to have_content "To comment this document you must sign_in or sign_up."
    end
  end
end
