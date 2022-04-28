require_dependency Rails.root.join("app", "components", "layout", "top_links_component").to_s

class Layout::TopLinksComponent
  private

    def top_links_content_block
      SiteCustomization::ContentBlock.block_for("top_links", I18n.locale)
    end
end
