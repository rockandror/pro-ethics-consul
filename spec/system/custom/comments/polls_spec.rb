require "rails_helper"

describe "Commenting polls" do
  let(:poll) { create(:poll) }

  context "Does not render comments section" do
    scenario "For users guests" do
      visit poll_path(poll)

      expect(page).not_to have_content "Comments"
    end

    scenario "For identified users" do
      login_as(create(:administrator).user)

      visit poll_path(poll)

      expect(page).not_to have_content "Comments"
    end
  end
end
