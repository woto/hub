# frozen_string_literal: true

module Extractors
  module Metadata
    class Scrapper
      include ApplicationInteractor

      def call
        begin
          url = URI::HTTP.build([nil, ENV.fetch('SCRAPPER_HOST'), ENV.fetch('SCRAPPER_PORT'),
                                 '/screenshot', "url=#{context.url}", nil])

          result = connection.get(url)
          context.object = result.body
        rescue Faraday::Error => e
          Rails.logger.error(e)
          fail!(message: e.message)
        end
      end

      private

      def connection
        Faraday.new(url: context.url) do |faraday|
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
