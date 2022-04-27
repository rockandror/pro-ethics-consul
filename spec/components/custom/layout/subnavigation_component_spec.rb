require "rails_helper"

describe Layout::SubnavigationComponent do
  describe "#render?" do
    before do
      Setting["feature.help_page"] = false
      Setting["feature.sdg"] = false
      Setting["process.budgets"] = false
      Setting["process.debates"] = false
      Setting["process.legislation"] = false
      Setting["process.polls"] = true
      Setting["process.proposals"] = false
    end

    it "is not rendered when only one feature is enabled" do
      render_inline Layout::SubnavigationComponent.new

      expect(page).not_to be_rendered
    end

    it "is rendered when more features are enabled" do
      Setting["feature.debates"] = true

      render_inline Layout::SubnavigationComponent.new

      expect(page).to have_link "Debates"
      expect(page).to have_link "Voting"
    end

    it "is rendered when there's a content block with left navigation links" do
      SiteCustomization::ContentBlock.create!(
        name: "subnavigation_left",
        locale: I18n.locale,
        body: "<li><a href='/'>My link</a><li>"
      )

      render_inline Layout::SubnavigationComponent.new

      expect(page).to have_link "My link"
      expect(page).to have_link "Voting"
    end

    it "is rendered when there's a content block with right navigation links" do
      SiteCustomization::ContentBlock.create!(
        name: "subnavigation_right",
        locale: I18n.locale,
        body: "<li><a href='/'>My link</a><li>"
      )

      render_inline Layout::SubnavigationComponent.new

      expect(page).to have_link "My link"
      expect(page).to have_link "Voting"
    end
  end
end
