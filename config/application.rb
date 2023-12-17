require_relative "boot"

require "rails/all"

require 'devise'

Bundler.require(*Rails.groups)

module LoanManagement
  class Application < Rails::Application
    config.load_defaults 6.1

    config.cache_store = :redis_cache_store, { url: "redis://localhost:6379/0" }
  end
end
