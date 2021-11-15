# frozen_string_literal: true

module Interactors
  module Tools
    class ScrapeWebpage
      include ApplicationInteractor

      def call
        url = URI::HTTP.build([nil, ENV.fetch('SCRAPPER_HOST'), ENV.fetch('SCRAPPER_PORT'),
                               '/screenshot', "url=#{context.url}", nil])

        result = connection.get(url)
        context.object = {
          status: result.status,
          body: result.body
        }
      end

      private

      def connection
        Faraday.new(url: context.url) do |faraday|
          faraday.use FaradayMiddleware::FollowRedirects
          faraday.adapter Faraday.default_adapter
          faraday.response :json
          faraday.options.open_timeout = 10
          faraday.options.timeout = 20
        end
      end
    end
  end
end
