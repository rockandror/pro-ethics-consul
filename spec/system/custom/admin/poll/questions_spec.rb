require "rails_helper"

describe "Admin poll questions", :admin do
  scenario "Index" do
    poll1 = create(:poll)
    poll2 = create(:poll)
    poll3 = create(:poll)
    proposal = create(:proposal)
    question1 = create(:poll_question, :open_answer, poll: poll1)
    question2 = create(:poll_question, :single_choice, poll: poll2)
    question3 = create(:poll_question, :multiple_choice, poll: poll3, proposal: proposal)

    visit admin_poll_path(poll1)
    expect(page).to have_content(poll1.name)

    within("#poll_question_#{question1.id}") do
      expect(page).to have_content(question1.title)
      expect(page).not_to have_link "Edit answers"
      expect(page).to have_link "Edit"
      expect(page).to have_button "Delete"
    end

    visit admin_poll_path(poll2)
    expect(page).to have_content(poll2.name)

    within("#poll_question_#{question2.id}") do
      expect(page).to have_content question2.title
      expect(page).to have_link "Edit answers"
      expect(page).to have_link "Edit"
      expect(page).to have_button "Delete"
    end

    visit admin_poll_path(poll3)
    expect(page).to have_content(poll3.name)

    within("#poll_question_#{question3.id}") do
      expect(page).to have_content question3.title
      expect(page).to have_link "(See proposal)", href: proposal_path(question3.proposal)
      expect(page).to have_link "Edit answers"
      expect(page).to have_link "Edit"
      expect(page).to have_button "Delete"
    end
  end

  describe "Show" do
    scenario "does not render answers information for open answer questions" do
      question = create(:poll_question, :open_answer)
      visit admin_question_path(question)

      expect(page).not_to have_link("Add answer")
      expect(page).not_to have_content("Valid answers")
    end

    scenario "renders answers information for single and multiple choice questions" do
      question = create(:poll_question, %i[single_choice multiple_choice].sample)
      visit admin_question_path(question)

      expect(page).to have_link("Add answer")
      expect(page).to have_content("Valid answers")
    end
  end

  scenario "Create with optional answer" do
    poll = create(:poll, name: "Movies")
    title = "Star Wars: Episode IV - A New Hope"

    visit admin_poll_path(poll)
    click_link "Create question"

    expect(page).to have_content("Create question to poll Movies")
    expect(page).to have_selector("input[id='poll_question_poll_id'][value='#{poll.id}']",
                                   visible: :hidden)
    fill_in "Question", with: title

    click_button "Save"

    expect(page).to have_content(title)

    click_link "Edit question"

    expect(page).to have_field("Mandatory answer", checked: false)
  end

  scenario "Create with mandatory answer" do
    poll = create(:poll, name: "Movies")
    title = "Star Wars: Episode IV - A New Hope"

    visit admin_poll_path(poll)
    click_link "Create question"

    fill_in "Question", with: title
    check "Mandatory answer"

    click_button "Save"

    expect(page).to have_content(title)

    click_link "Edit question"

    expect(page).to have_checked_field("Mandatory answer")
  end

  scenario "Create with description" do
    poll = create(:poll, name: "Movies")

    visit admin_poll_path(poll)
    click_link "Create question"

    fill_in "Question", with: "Star Wars: Episode IV - A New Hope"
    fill_in "Description", with: "Useful description for question"

    click_button "Save"

    expect(page).to have_content("Useful description for question")
  end

  scenario "Create with validator" do
    poll = create(:poll, name: "Movies")
    title = "What is the postal code of your town?"

    visit admin_poll_path(poll)
    click_link "Create question"

    fill_in "Question", with: title
    select "Postal code", from: "Validator"

    click_button "Save"

    expect(page).to have_content(title)

    click_link "Edit question"

    expect(page).to have_field "Validator", with: "postal_code"
  end
end
