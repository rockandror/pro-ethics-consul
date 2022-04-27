require "rails_helper"

describe Layout::ResponsiveMenuComponent do
  describe "#render?" do
    let!(:default_sign_in_links) { Rails.application.config.sign_in_links }

    before do
      Setting["feature.help_page"] = false
      Setting["feature.sdg"] = false
      Setting["process.budgets"] = false
      Setting["process.debates"] = false
      Setting["process.legislation"] = false
      Setting["process.polls"] = true
      Setting["process.proposals"] = false
      Rails.application.config.sign_in_links = false
    end

    after { Rails.application.config.sign_in_links = default_sign_in_links }

    it "is not rendered if there's no content to render" do
      render_inline Layout::ResponsiveMenuComponent.new

      expect(page).not_to be_rendered
    end

    it "is rendered if the subnavigation is rendered" do
      Setting["process.debates"] = true

      render_inline Layout::ResponsiveMenuComponent.new

      expect(page).to have_link "Debates"
    end

    it "is rendered if there are top links" do
      SiteCustomization::ContentBlock.create!(
        name: "top_links",
        locale: I18n.locale,
        body: "<li><a href='/'>My link</a><li>"
      )

      render_inline Layout::ResponsiveMenuComponent.new

      expect(page).to have_link "My link"
    end

    it "is rendered if there are sign in links" do
      Rails.application.config.sign_in_links = true

      render_inline Layout::ResponsiveMenuComponent.new

      expect(page).to have_link "Sign in"
    end

    it "is rendered for identified users" do
      sign_in(create(:administrator).user)

      render_inline Layout::ResponsiveMenuComponent.new

      expect(page).to have_link "Sign out"
    end
  end
end
