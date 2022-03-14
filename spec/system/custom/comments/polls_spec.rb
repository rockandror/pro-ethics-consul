require "rails_helper"

describe "Commenting polls" do
  let(:poll) { create(:poll) }

  scenario "is not available for guest users" do
    visit poll_path(poll)

    expect(page).not_to have_link "Comments (0)"
  end
end
