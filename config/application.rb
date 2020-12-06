# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Webapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.generators do |g|
      g.test_framework :rspec,
                       controller_specs: false,
                       fixtures: false,
                       view_specs: false,
                       routing_specs: false
    end

    # WARN -- : Can't verify CSRF token authenticity.の警告ログを消す（検証は行っている）
    config.action_controller.log_warning_on_csrf_failure = false
  end
end
