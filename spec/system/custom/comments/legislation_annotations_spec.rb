require "rails_helper"

describe "Commenting legislation questions" do
  let(:user) { create :user }
  let(:legislation_annotation) { create :legislation_annotation, author: user }

  describe "Not logged user" do
    scenario "can see comments forms", :consul do
      create(:comment, commentable: legislation_annotation)
      visit legislation_process_draft_version_annotation_path(legislation_annotation.draft_version.process,
                                                              legislation_annotation.draft_version,
                                                              legislation_annotation)

      expect(page).not_to have_content "You must sign in or sign up to leave a comment"
      within("#comments") do
        expect(page).to have_content "Write a comment"
        expect(page).to have_content "Reply"
      end
    end
  end
end
