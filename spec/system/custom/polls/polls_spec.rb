require "rails_helper"

describe "Polls" do
  describe "Index" do
    scenario "Displays icon correctly", :consul do
      create_list(:poll, 3)

      visit polls_path

      expect(page).not_to have_css(".not-logged-in")
      expect(page).not_to have_content("You must sign in or sign up to participate")

      user = create(:user)
      login_as(user)

      visit polls_path

      expect(page).to have_css(".unverified", count: 3)
      expect(page).to have_content("You must verify your account to participate")
    end
  end

  context "Show" do
    let(:geozone) { create(:geozone) }
    let(:poll) { create(:poll, summary: "Summary", description: "Description") }

    scenario "Level 2 users who have already answered" do
      question = create(:poll_question, :yes_no, poll: poll)
      no = question.question_answers.last
      user = create(:user, :level_two)
      create(:poll_answer, question: question, author: user, answer: no)

      login_as user
      visit poll_path(poll)

      within("#poll_question_#{question.id}_answers") do
        expect(page).to have_link("Yes")
        expect(page).to have_link("No")
      end
    end

    scenario "Guest users can answer the poll questions" do
      Setting["feature.user.skip_verification"] = true
      question = create(:poll_question, :yes_no, poll: poll)

      visit poll_path(poll)

      within("#poll_question_#{question.id}_answers") do
        click_link "Yes"

        expect(page).not_to have_link("Yes")
        expect(page).to have_link("No")

        click_link "No"

        expect(page).not_to have_link("No")
        expect(page).to have_link("Yes")
      end
    end
  end
end
