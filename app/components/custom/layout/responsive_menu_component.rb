class Layout::ResponsiveMenuComponent < ApplicationComponent
  delegate :current_user, to: :helpers

  def render?
    show_sign_in_links? || Layout::SubnavigationComponent.new.render? || Layout::TopLinksComponent.new.render?
  end

  private

    def show_sign_in_links?
      current_user && !current_user.guest || Rails.application.config.sign_in_links
    end
end
