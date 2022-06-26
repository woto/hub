# frozen_string_literal: true

module Extractors
  module Metadata
    class Iframely
      include ApplicationInteractor
      include Rails.application.routes.url_helpers

      def call
        url = URI::HTTP.build([nil, ENV.fetch('IFRAMELY_HOST'), ENV.fetch('IFRAMELY_PORT'),
                               '/iframely', "url=#{context.url}", nil])

        result = connection.get(url)
        context.object = result.body
      rescue Faraday::Error => e
        Rails.logger.error(e)
        fail!(code: e.response_status, message: e.message)
      end

      private

      def connection
        Faraday.new do |faraday|
          # faraday.response :logger # log requests and responses to $stdout
          faraday.response :follow_redirects # follow redirects
          faraday.response :raise_error # raises an exception if response is a 4xx or 5xx code
          faraday.request :json # encode req bodies as JSON
          faraday.response :json # decode response bodies as JSON
          faraday.options.read_timeout = 60
          faraday.options.open_timeout = 60
          faraday.options.timeout = 60
        end
      end
    end
  end
end
