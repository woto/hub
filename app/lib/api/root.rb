# frozen_string_literal: true

require 'grape-swagger'
# require 'warden'

module API
  class Root < Grape::API

    # use Warden::Manager do |manager|
    #   manager.default_strategies :api_key
    #   manager.failure_app = ->(_env) { [401, {}, ['Not authorized']] }
    # end

    format :json
    rescue_from :grape_exceptions
    # TODO: use ActionDispatch::ExceptionWrapper (for logging like it does Rails)
    # TODO: also must send to Sentry
    rescue_from :all do |e|
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      error!(e)
    end

    helpers do
      def current_user
        env['warden'].user
      end
    end

    Grape::Middleware::Auth::Strategies.add(:api_key, APIKeyMiddleware)
    auth :api_key

    mount Tools

    add_swagger_documentation(
      {
        security_definitions: { api_key: { type: 'apiKey', name: 'api_key', in: 'header' } },
        security: [{ api_key: [] }]
      }
    )
  end
end
