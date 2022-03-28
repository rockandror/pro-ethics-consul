require "rails_helper"

describe "Polls" do
  before { Setting["feature.user.skip_verification"] = true }

  describe "Index" do
    scenario "Displays icon correctly for guest users" do
      poll = create(:poll)
      create(:poll_question, :yes_no, poll: poll)

      visit polls_path

      expect(page).not_to have_css(".not-logged-in")
      expect(page).not_to have_content("You must sign in or sign up to participate")

      visit poll_path(poll)

      choose "Yes"
      click_button "Vote"

      expect(page).to have_content("Poll saved successfully!")

      visit polls_path

      expect(page).to have_css(".already-answer")
      expect(page).to have_content("You already have participated in this poll")
    end
  end

  context "Show" do
    let(:poll) { create(:poll) }

    scenario "Question answers appear in the given order" do
      question = create(:poll_question, poll: poll)
      answer1 = create(:poll_question_answer, title: "First answer", question: question, given_order: 2)
      answer2 = create(:poll_question_answer, title: "Second answer", question: question, given_order: 1)

      visit poll_path(poll)

      expect(answer2.title).to appear_before(answer1.title)
    end

    scenario "Guest users in an expired poll" do
      expired_poll = create(:poll, :expired)

      create(:poll_question, :yes_no, poll: expired_poll)

      visit poll_path(expired_poll)

      expect(page).to have_field("Yes", disabled: true)
      expect(page).to have_field("No", disabled: true)
      expect(page).to have_button("Vote", disabled: true)
      expect(page).to have_content("This poll has finished")
    end

    scenario "Show form errors when any answer is invalid" do
      poll = create(:poll)
      open_question = create(:poll_question, poll: poll, mandatory_answer: true)
      single_choice_question = create(:poll_question, :yes_no, poll: poll, mandatory_answer: true)

      visit poll_path(poll)
      click_button "Vote"

      within "#question_#{open_question.id}_answer_fields" do
        expect(page).to have_content("can't be blank")
      end
      within "#question_#{single_choice_question.id}_answer_fields" do
        expect(page).to have_content("Answer can't be blank")
      end
    end

    scenario "Show fullfilled form when answers were saved successfully" do
      poll = create(:poll)
      open_question = create(:poll_question, poll: poll)
      single_choice_question = create(:poll_question, :yes_no, poll: poll)
      visit poll_path(poll)

      fill_in open_question.title, with: "Open answer to question 1"
      choose "Yes"
      click_button "Vote"

      expect(page).to have_content("You have already participated in this poll.")
      expect(page).to have_content("If you vote again it will be overwritten.")
      within "#question_#{open_question.id}_answer_fields" do
        expect(page).to have_field(open_question.title, with: "Open answer to question 1")
      end
      within "#question_#{single_choice_question.id}_answer_fields" do
        expect(page).to have_field("Yes", checked: true)
        expect(page).to have_field("No", checked: false)
      end
    end

    scenario "Guest users can answer the poll questions" do
      create(:poll_question, :yes_no, poll: poll)
      visit poll_path(poll)

      choose "Yes"
      click_button "Vote"

      expect(page).to have_content("Poll saved successfully!")
      expect(page).to have_field("Yes", checked: true)
      expect(page).to have_field("No", checked: false)
    end

    scenario "Allow to update answers" do
      poll = create(:poll)
      open_question = create(:poll_question, poll: poll)
      single_choice_question = create(:poll_question, :yes_no, poll: poll)

      visit poll_path(poll)
      fill_in open_question.title, with: "Open answer"
      choose "Yes"
      click_button "Vote"

      within "#question_#{open_question.id}_answer_fields" do
        expect(page).to have_field(open_question.title, with: "Open answer")
      end
      within "#question_#{single_choice_question.id}_answer_fields" do
        expect(page).to have_field("Yes", checked: true)
        expect(page).to have_field("No", checked: false)
      end

      fill_in open_question.title, with: "Open answer update"
      choose "No"
      click_button "Vote"

      expect(page).to have_content("Poll saved successfully!")
      within "#question_#{open_question.id}_answer_fields" do
        expect(page).to have_field(open_question.title, with: "Open answer update")
      end
      within "#question_#{single_choice_question.id}_answer_fields" do
        expect(page).to have_field("Yes", checked: false)
        expect(page).to have_field("No", checked: true)
      end
    end

    scenario "Show questions descriptions when defined" do
      poll = create(:poll)
      open_question = create(:poll_question, poll: poll, description: "Open question description")
      open_question_no_decription = create(:poll_question, poll: poll)
      single_choice_question = create(:poll_question, :yes_no, poll: poll,
        description: "Single choice question description")
      single_choice_question_no_description = create(:poll_question, :yes_no, poll: poll)

      visit poll_path(poll)

      within "#question_#{open_question.id}_answer_fields" do
        expect(page).to have_css("span.help-text", text: "Open question description")
      end
      within "#question_#{single_choice_question.id}_answer_fields" do
        expect(page).to have_css("span.help-text", text: "Single choice question description")
      end
      within "#question_#{open_question_no_decription.id}_answer_fields" do
        expect(page).not_to have_css("span.help-text")
      end
      within "#question_#{single_choice_question_no_description.id}_answer_fields" do
        expect(page).not_to have_css("span.help-text")
      end
    end
  end
end
