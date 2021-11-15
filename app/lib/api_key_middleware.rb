# frozen_string_literal: true

class APIKeyMiddleware < Rack::Auth::AbstractHandler
  def call(env)
    unless env['REQUEST_URI'] == '/swagger_doc'
      result = env['warden'].authenticate :api_key
      throw :warden unless result
    end

    @app.call(env)
  end
end
