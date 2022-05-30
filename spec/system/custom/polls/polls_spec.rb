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
      check "By answering you accept the terms and conditions of use"
      click_button "Vote"

      expect(page).to have_content("Poll saved successfully!")

      visit polls_path

      expect(page).to have_css(".already-answer")
      expect(page).to have_content("You already have participated in this poll")
    end
  end

  context "Show" do
    let(:poll) { create(:poll) }

    scenario "Navigation" do
      visit poll_path(poll)

      expect(page).not_to have_link "Back to voting"
      expect(page).not_to have_link "Back to proposal"
    end

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
      check "By answering you accept the terms and conditions of use"
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
      check "By answering you accept the terms and conditions of use"
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
      check "By answering you accept the terms and conditions of use"
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

    scenario "Show answers descriptions fields when defined" do
      poll = create(:poll, answers_descriptions_link_text: "You can find the answer descriptions...",
                           answers_descriptions_title: "Answers descriptions for poll")
      question = create(:poll_question, poll: poll)
      create(:poll_question_answer, question: question, title: "Yes")

      visit poll_path(poll)

      expect(page).to have_content "You can find the answer descriptions..."
      expect(page).to have_link "Read more"
      expect(page).to have_content "Answers descriptions for poll"
    end
  end

  describe "Answer" do
    let(:poll) { create(:poll) }

    scenario "Answer poll with invisible_captcha honeypot field", :no_js do
      visit poll_path(poll)

      fill_in :title, with: "I am a bot"
      click_button "Vote"

      expect(page.status_code).to eq(200)
      expect(page.html).to be_empty
      expect(page).to have_current_path(answer_poll_path(poll))
    end

    scenario "Answer poll too fast" do
      allow(InvisibleCaptcha).to receive(:timestamp_threshold).and_return(Float::INFINITY)
      visit poll_path(poll)

      click_button "Vote"

      expect(page).to have_content "Sorry, that was too quick! Please resubmit"
      expect(page).to have_current_path(poll_path(poll))
    end

    scenario "Shows errors on create" do
      create(:poll_question, poll: poll, mandatory_answer: true)
      visit poll_path(poll)

      click_button "Vote"

      expect(page).to have_content "2 errors prevented your answers from being saved. Please check the " \
                                   "marked fields to know how to correct them:"
    end

    scenario "Does not persist user answers when the terms and conditions are not accepted" do
      create(:poll_question, :yes_no, poll: poll)
      visit poll_path(poll)

      choose "Yes"
      click_button "Vote"

      expect(page).to have_content "1 error prevented your answers from being saved. Please check the " \
                                   "marked field to know how to correct it:"
      expect(page).to have_field("Yes", checked: true)
      expect(page).to have_content "must be accepted"
    end

    scenario "Does not show and do not require the terms and conditions when updating" do
      create(:poll_question, :yes_no, poll: poll)
      visit poll_path(poll)

      expect(page).to have_field("By answering you accept the terms and conditions of use")

      choose "Yes"
      check "By answering you accept the terms and conditions of use"
      click_button "Vote"

      expect(page).to have_content("Poll saved successfully!")
      expect(page).not_to have_field("By answering you accept the terms and conditions of use")

      choose "No"
      click_button "Vote"

      expect(page).to have_content("Poll saved successfully!")
    end
  end
end
