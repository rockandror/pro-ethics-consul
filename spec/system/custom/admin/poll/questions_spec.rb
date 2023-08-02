require "rails_helper"

describe "Admin poll questions", :admin do
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

  describe "show" do
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
end
