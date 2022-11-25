require "rails_helper"

describe GuestInformation::FormComponent do
  let(:guest) { create(:guest) }
  let(:component) { GuestInformation::FormComponent.new }

  before { sign_in(guest) }

  it "renders guest information form" do
    render_inline component

    expect(page).to have_css "#guest-information-form"
    expect(page).to have_field "Name"
    expect(page).to have_field "Email"
    expect(page).to have_button "Update"
  end
end
