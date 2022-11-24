require "rails_helper"

describe GuestInformation do
  let(:guest_information) { build(:guest_information) }

  it "is valid" do
    expect(guest_information).to be_valid
  end

  it "is valid without name" do
    guest_information.name = nil
    expect(guest_information).to be_valid
  end

  it "is invalid without email" do
    guest_information.email = nil
    expect(guest_information).not_to be_valid
  end

  it "is not valid without a user" do
    guest_information.user = nil
    expect(guest_information).not_to be_valid
  end

  it "is not valid for the same user" do
    guest_information.save!
    new_guest_information = build(:guest_information, user: guest_information.user)
    expect(new_guest_information).not_to be_valid
    expect(new_guest_information.errors.full_messages).to include("User has already been taken")
  end
end
