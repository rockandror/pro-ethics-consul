class GuestInformationsController < ApplicationController
  include GuestUsers
  skip_authorization_check
  skip_before_action :verify_authenticity_token

  def update
    @guest_information = current_user.guest_information

    respond_to do |format|
      format.html do
        if @guest_information.update(guest_information_params)
          flash[:notice] = t("guest_information.update.success_notice")
        else
          flash[:alert] = t("guest_information.update.alert_error")
        end
        redirect_to request.referer + "#guest-information-form"
      end
      format.js do
        if @guest_information.update(guest_information_params)
          flash.now[:notice] = t("guest_information.update.success_notice")
        end
        render :update
      end
    end
  end

  private

    def guest_information_params
      params.require(:guest_information).permit(allowed_params)
    end

    def allowed_params
      [:name, :email]
    end
end
