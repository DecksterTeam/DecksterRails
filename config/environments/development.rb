require "#{Rails.root}/config/environments/common"

Mtheory::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.

  # these two have been changed to true to enable concurrency in development.
  # unfortunately, this means the server must be restarted to enable live code reloading.
  # to go back, can change these to false and disable the notification EventSource JS calls
  #config.cache_classes = true
  #config.eager_load = true

  # Show full error reports and disable caching
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Expands the lines which load the assets
  config.assets.debug = true

  config.basic_auth = false
end
