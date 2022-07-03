require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mysize
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.i18n.default_locale = :ja
    config.load_defaults 5.1
    config.time_zone = 'Tokyo'

    #認証トークンをremoteフォームに埋め込む(ブラウザ側でJSが無効になっていた場合にAjaxを機能させる)
    config.action_view.embed_authenticity_token_in_remote_forms = true

    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/config/locales)
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    # Set test generation on Rspec
    config.generators do |g|
      g.test_framework :rpsec
    end

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins ENV["FRONTEND_ORIGIN"]
        resource "/api/*",
                 headers: :any,
                 methods: [:get, :post, :patch, :delete, :options, :head]
      end
    end


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
