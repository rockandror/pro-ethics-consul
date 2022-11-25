class GuestInformation::FormComponent < ApplicationComponent
  delegate :current_user, to: :helpers

  def guest_information
    return current_user.guest_information if current_user.guest_information

    current_user.build_guest_information
    current_user.guest_information.save!(validate: false)
    current_user.guest_information
  end
end
