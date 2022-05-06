require_dependency Rails.root.join("app", "components", "layout", "locale_switcher_component").to_s

class Layout::LocaleSwitcherComponent < ApplicationComponent
  private

    def many_locales?
      locales.size > 6
    end
end
