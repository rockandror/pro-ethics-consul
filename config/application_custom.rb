module Consul
  class Application < Rails::Application
    config.i18n.available_locales = %w[en]

    config.autoload_paths << "#{Rails.root}/app/controllers/custom/concerns"
    config.sign_in_links = Rails.env.test?
  end
end
