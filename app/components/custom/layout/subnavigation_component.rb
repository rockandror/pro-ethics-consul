class Layout::SubnavigationComponent < ApplicationComponent
  delegate :content_block, :layout_menu_link_to, to: :helpers

  def render?
    content_block("subnavigation_left").present? ||
      content_block("subnavigation_right").present? ||
      enabled_features.count > 1
  end

  private

    def enabled_features
      [
        feature?(:debates),
        feature?(:proposals),
        feature?(:polls),
        feature?(:legislation),
        feature?(:budgets),
        feature?(:sdg),
        feature?(:help_page)
      ].select(&:present?)
    end
end
