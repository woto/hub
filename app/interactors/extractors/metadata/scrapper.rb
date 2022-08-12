# frozen_string_literal: true

module Extractors
  module Metadata
    class Scrapper
      include ApplicationInteractor

      def call
        url = URI::HTTP.build([nil, ENV.fetch('SCRAPPER_HOST'), ENV.fetch('SCRAPPER_PORT'),
                               '/screenshot', "url=#{context.url}", nil])

        result = connection.get(url)
        context.object = result.body
      rescue Faraday::TimeoutError => e
        Rails.logger.error(e)
        fail!(code: 504, message: e.message)
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
          faraday.options.open_timeout = 60
          faraday.options.timeout = 60
          faraday.options.read_timeout = 60
        end
      end
    end
  end
end
