RSpec.configure do |config|
  # Add the :consul tag to tests which make sense in the original
  # version of CONSUL but don't make sense in your application due to
  # the custom changes you've implemented.
  #
  # Using this tag will help maintaining the test suite when doing
  # custom changes and when upgrading to a newer version of CONSUL
  config.filter_run_excluding consul: true

  config.around(:each, :disable_sign_in_links) do |example|
    default_sign_in_config = Rails.application.config.sign_in_links
    Rails.application.config.sign_in_links = false

    begin
      example.run
    ensure
      Rails.application.config.sign_in_links = default_sign_in_config
    end
  end
end
