require "rails_helper"

describe "Stats", :admin do
  context "Polls" do
    scenario "Total participants by origin" do
      create(:poll_officer_assignment)
      3.times { create(:poll_voter, origin: "web") }

      visit polls_admin_stats_path

      within("#web_participants") do
        expect(page).to have_content "3"
      end
    end

    scenario "Total participants" do
      user = create(:user, :level_two)
      3.times { create(:poll_voter, user: user) }
      create(:poll_voter)

      visit polls_admin_stats_path

      within("#participants") do
        expect(page).to have_content "2"
      end
    end

    scenario "Participants by poll" do
      poll1 = create(:poll)
      poll2 = create(:poll)

      1.times { create(:poll_voter, poll: poll1, origin: "web") }
      2.times { create(:poll_voter, poll: poll2, origin: "web") }

      visit polls_admin_stats_path

      within("#polls") do
        within("#poll_#{poll1.id}") do
          expect(page).to have_content "1"
        end

        within("#poll_#{poll2.id}") do
          expect(page).to have_content "2"
        end
      end
    end

    scenario "Participants by poll question" do
      user1 = create(:user, :level_two)
      user2 = create(:user, :level_two)

      poll = create(:poll)

      question1 = create(:poll_question, :yes_no, poll: poll)
      question2 = create(:poll_question, :yes_no, poll: poll)

      create(:poll_answer, question: question1, author: user1)
      create(:poll_answer, question: question2, author: user1)
      create(:poll_answer, question: question2, author: user2)

      visit polls_admin_stats_path

      within("#poll_question_#{question1.id}") do
        expect(page).to have_content "1"
      end

      within("#poll_question_#{question2.id}") do
        expect(page).to have_content "2"
      end

      within("#poll_#{poll.id}_questions_total") do
        expect(page).to have_content "2"
      end
    end
  end
end
