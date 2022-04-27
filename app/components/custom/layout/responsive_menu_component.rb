class Layout::ResponsiveMenuComponent < ApplicationComponent
  delegate :current_user, to: :helpers
end
