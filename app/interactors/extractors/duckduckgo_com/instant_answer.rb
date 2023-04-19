# frozen_string_literal: true

module Extractors
  module DuckduckgoCom
    class InstantAnswer
      include ApplicationInteractor
      include Rails.application.routes.url_helpers

      def call
        conn = Faraday.new do |faraday|
          # faraday.response :logger # log requests and responses to $stdout
          faraday.response :follow_redirects # follow redirects
          faraday.response :raise_error # raises an exception if response is a 4xx or 5xx code
          faraday.request :json # encode req bodies as JSON
          # faraday.response :json # decode response bodies as JSON
          # NOTE: duckduckgo disrespect standards
          faraday.response :json, content_type: %r{application/x-javascript}
        end

        res = begin
          conn.get('https://api.duckduckgo.com', {
                     q: context.q,
                     format: 'json'
                   })
        rescue Faraday::Error => e
          Rails.logger.error(e)
          fail!(message: e.message)
        end

        context.object = res.body
      end
    end
  end
end
