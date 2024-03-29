require "rails_helper"

describe "Admin polls", :admin do
  scenario "Create poll with descriptions fields" do
    visit new_admin_poll_path

    start_date = 1.week.from_now.to_date
    end_date = 2.weeks.from_now.to_date

    fill_in "Name", with: "Upcoming poll"
    fill_in "poll_starts_at", with: start_date
    fill_in "poll_ends_at", with: end_date
    fill_in "Summary", with: "Upcoming poll's summary. This poll..."
    fill_in "Text next to the link to jump to the answers description section",
            with: "You can find the answer descriptions..."
    fill_in "Description", with: "Upcomming poll's description. This poll..."
    fill_in "Answers descriptions title", with: "Answers descriptions for poll"

    click_button "Create poll"

    expect(page).to have_content "Poll created successfully"

    visit admin_polls_path

    click_link "Edit"

    expect(page).to have_content "You can find the answer descriptions..."
    expect(page).to have_field "Answers descriptions title", with: "Answers descriptions for poll"
  end

  context "Results" do
    context "Poll show" do
      scenario "Show partial results" do
        poll = create(:poll)

        booth_assignment_1 = create(:poll_booth_assignment, poll: poll)
        booth_assignment_2 = create(:poll_booth_assignment, poll: poll)
        booth_assignment_3 = create(:poll_booth_assignment, poll: poll)

        question_1 = create(:poll_question, poll: poll)
        create(:poll_question_answer, title: "Oui", question: question_1)
        create(:poll_question_answer, title: "Non", question: question_1)

        question_2 = create(:poll_question, poll: poll)
        create(:poll_question_answer, title: "Aujourd'hui", question: question_2)
        create(:poll_question_answer, title: "Demain", question: question_2)

        [booth_assignment_1, booth_assignment_2, booth_assignment_3].each do |ba|
          create(:poll_partial_result,
                 booth_assignment: ba,
                 question: question_1,
                 answer: question_1.question_answers.first,
                 amount: 11)

          create(:poll_partial_result,
                 booth_assignment: ba,
                 question: question_2,
                 answer: question_2.question_answers.last,
                 amount: 5)
        end

        create(:poll_recount,
               booth_assignment: booth_assignment_1,
               white_amount: 21,
               null_amount: 44,
               total_amount: 66)

        visit admin_poll_results_path(poll)

        expect(page).to have_content "Results by booth"
      end

      scenario "Results by answer" do
        poll = create(:poll)
        booth_assignment_1 = create(:poll_booth_assignment, poll: poll)
        booth_assignment_2 = create(:poll_booth_assignment, poll: poll)
        booth_assignment_3 = create(:poll_booth_assignment, poll: poll)

        question_1 = create(:poll_question, :yes_no, poll: poll)

        question_2 = create(:poll_question, poll: poll)
        create(:poll_question_answer, title: "Today", question: question_2)
        create(:poll_question_answer, title: "Tomorrow", question: question_2)

        [booth_assignment_1, booth_assignment_2, booth_assignment_3].each do |ba|
          create(:poll_partial_result,
                  booth_assignment: ba,
                  question: question_1,
                  answer: question_1.question_answers.first,
                  amount: 11)
          create(:poll_partial_result,
                  booth_assignment: ba,
                  question: question_2,
                  answer: question_2.question_answers.last,
                  amount: 5)
        end
        create(:poll_recount,
               booth_assignment: booth_assignment_1,
               white_amount: 21,
               null_amount: 44,
               total_amount: 66)

        visit admin_poll_path(poll)

        click_link "Results"

        expect(page).to have_content(question_1.title)
        question_1.question_answers.each_with_index do |answer, i|
          within("#question_#{question_1.id}_#{i}_result") do
            expect(page).to have_content(answer.title)
            expect(page).to have_content([33, 0][i])
          end
        end

        expect(page).to have_content(question_2.title)
        question_2.question_answers.each_with_index do |answer, i|
          within("#question_#{question_2.id}_#{i}_result") do
            expect(page).to have_content(answer.title)
            expect(page).to have_content([0, 15][i])
          end
        end

        within("#white_results") { expect(page).to have_content("21") }
        within("#null_results") { expect(page).to have_content("44") }
        within("#total_results") { expect(page).to have_content("66") }
      end

      scenario "Link to results by booth" do
        poll = create(:poll)
        booth_assignment1 = create(:poll_booth_assignment, poll: poll)
        booth_assignment2 = create(:poll_booth_assignment, poll: poll)

        question = create(:poll_question, :yes_no, poll: poll)

        create(:poll_partial_result,
               booth_assignment: booth_assignment1,
               question: question,
               answer: question.question_answers.first,
               amount: 5)

        create(:poll_partial_result,
               booth_assignment: booth_assignment2,
               question: question,
               answer: question.question_answers.first,
               amount: 6)

        visit admin_poll_path(poll)

        click_link "Results"

        expect(page).to have_link("See results", count: 2)

        within("#booth_assignment_#{booth_assignment1.id}_result") do
          click_link "See results"
        end

        expect(page).to have_content booth_assignment1.booth.name
        expect(page).to have_content "Results"
        expect(page).to have_content "Yes"
        expect(page).to have_content "5"
      end
    end
  end

  context "Selecting csv", :no_js do
    scenario "Downloading CSV file", :admin do
      user_1 = create(:user, :level_two)
      user_2 = create(:user, :level_two)
      poll = create(:poll, :expired, name: "Questions to citizens")
      question_1 = create(:poll_question, poll: poll, title: "What is your favourite color?")
      create(:poll_answer, question: question_1, open_answer: "Red", author: user_1)
      create(:poll_answer, question: question_1, open_answer: "Blue", author: user_2)
      question_2 = create(:poll_question, :yes_no, poll: poll, title: "Do you agree?")
      create(:poll_answer, question: question_2, question_answer: question_2.question_answers.first, author: user_1)
      create(:poll_answer, question: question_2, question_answer: question_2.question_answers.last, author: user_2)
      question_3 = create(:poll_question, :yes_no, poll: poll, title: "Do you have environmental concerns?")
      create(:poll_answer, question: question_3, question_answer: question_3.question_answers.first, author: user_1)
      create(:poll_answer, question: question_3, question_answer: nil, author: user_2)
      question_4 = create(:poll_question, :multiple_choice, poll: poll, title: "Choose many")
      option_a = create(:poll_question_answer, question: question_4, title: "Option A")
      option_b = create(:poll_question_answer, question: question_4, title: "Option B")
      option_c = create(:poll_question_answer, question: question_4, title: "Option C")
      create(:poll_answer, question: question_4, question_answers: [option_a, option_c], author: user_1)
      create(:poll_answer, question: question_4, question_answers: [option_b], author: user_2)
      create(:poll_voter, user: user_1, poll: poll)
      create(:poll_voter, user: user_2, poll: poll)

      visit admin_poll_path(poll)
      click_link "Download polls results"

      header = page.response_headers["Content-Disposition"]
      expect(header).to match(/^attachment/)
      expect(header).to match(/filename="questions_to_citizens_questions_answers.csv"$/)
      csv_contents = "What is your favourite color?,Do you agree?,Do you have environmental concerns?,Choose many\n"\
                     "Red,Yes,Yes,Option A;Option C\n"\
                     "Blue,No,,Option B\n"\

      expect(page.body).to eq(csv_contents)
    end
  end

  context "Show" do
    scenario "does not render edit answers link for open answer questions" do
      question = create(:poll_question, :open_answer)

      visit admin_poll_path(question.poll)

      expect(page).not_to have_link("Edit answers")
    end

    scenario "renders edit answers link for single and multiple choice questions" do
      question = create(:poll_question, %i[single_choice multiple_choice].sample)

      visit admin_poll_path(question.poll)

      expect(page).to have_link("Edit answers")
    end
  end
end
