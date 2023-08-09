require "rails_helper"

describe "Answers", :admin do
  scenario "Create" do
    question = create(:poll_question, %i[single_choice multiple_choice].sample)

    visit admin_question_path(question)
    click_link "Add answer"

    fill_in "Answer", with: "The answer is always 42"
    fill_in_ckeditor "Description", with: "The Hitchhiker's Guide To The Universe"

    click_button "Save"

    expect(page).to have_content "The answer is always 42"
    expect(page).to have_content "The Hitchhiker's Guide To The Universe"
  end

  scenario "Create second answer and place after the first one" do
    question = create(:poll_question, %i[single_choice multiple_choice].sample)
    create(:poll_question_answer, title: "First", question: question, given_order: 1)

    visit admin_question_path(question)
    click_link "Add answer"

    fill_in "Answer", with: "Second"
    fill_in_ckeditor "Description", with: "Description"

    click_button "Save"

    expect("First").to appear_before("Second")
  end

  scenario "Update" do
    question = create(:poll_question, %i[single_choice multiple_choice].sample)
    answer = create(:poll_question_answer, question: question, title: "Answer title", given_order: 2)
    create(:poll_question_answer, question: question, title: "Another title", given_order: 1)

    visit admin_answer_path(answer)

    click_link "Edit answer"

    fill_in "Answer", with: "New title"

    click_button "Save"

    expect(page).to have_content "Changes saved"
    expect(page).to have_content "New title"

    visit admin_question_path(question)

    expect(page).not_to have_content "Answer title"

    expect("Another title").to appear_before("New title")
  end

  scenario "Reorder" do
    question = create(:poll_question, %i[single_choice multiple_choice].sample)
    create(:poll_question_answer, question: question, title: "First", given_order: 1)
    create(:poll_question_answer, question: question, title: "Last", given_order: 2)

    visit admin_question_path(question)

    within("tbody.sortable") do
      expect("First").to appear_before("Last")

      find("tr", text: "Last").drag_to(find("tr", text: "First"))

      expect("Last").to appear_before("First")
    end
  end

  scenario "can destroy poll question answers when it has no related answers" do
    poll_question_answer = create(:poll_question_answer)

    visit admin_question_path(poll_question_answer.question)

    accept_confirm { click_button "Delete" }

    expect(page).to have_content("Poll question answer deleted successfully!")
  end

  scenario "cannot destroy poll question answers it has related answers" do
    poll_question_answer = create(:poll_question_answer)
    create(:poll_answer, question: poll_question_answer.question, question_answer: poll_question_answer)

    visit admin_question_path(poll_question_answer.question)

    accept_confirm { click_button "Delete" }

    expect(page).to have_content("Cannot delete poll question answer because it already has user answers!")
  end

  scenario "cannot destroy poll question answers it has related partial results" do
    poll_question_answer = create(:poll_question_answer)
    create(:poll_partial_result, question: poll_question_answer.question, answer: poll_question_answer)

    visit admin_question_path(poll_question_answer.question)

    accept_confirm { click_button "Delete" }

    expect(page).to have_content("Cannot delete poll question answer because it already has user answers!")
  end
end
