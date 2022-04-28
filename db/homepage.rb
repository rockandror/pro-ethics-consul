Widget::Card.find_or_initialize_by(header: true, cardable_id: nil, cardable_type: "SiteCustomization::Page").update!(
  title_en: "Help us improve the world",
  description_en: "Let us know which challenges are the most important ones for you",
  link_text_en: "Vote now!",
  link_url: Rails.application.routes.url_helpers.poll_path(Poll.last)
)
