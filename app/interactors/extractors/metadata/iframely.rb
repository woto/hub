# frozen_string_literal: true

module Extractors
  module Metadata
    class Iframely
      include ApplicationInteractor
      include Rails.application.routes.url_helpers

      def call
        conn = Faraday.new do |faraday|
          # faraday.response :logger # log requests and responses to $stdout
          faraday.response :follow_redirects # follow redirects
          faraday.response :raise_error # raises an exception if response is a 4xx or 5xx code
          faraday.request :json # encode req bodies as JSON
          faraday.response :json # decode response bodies as JSON
          # faraday.options.read_timeout = 86400
          # faraday.options.open_timeout = 86400
          # faraday.options.timeout = 86400
        end

        res = begin
          # conn.get('https://iframe.ly/api/iframely', {
          #            url: context.url,
          #            api_key: ENV.fetch('IFRAMELY_KEY')
          #          })
          conn.get('http://localhost:8061/iframely', {
                     url: context.url
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
