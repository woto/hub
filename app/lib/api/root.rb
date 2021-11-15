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
    # rescue_from :all

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
