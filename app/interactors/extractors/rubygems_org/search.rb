# frozen_string_literal: true

module Extractors
  module RubygemsOrg
    class Search
      include ApplicationInteractor

      def call
        conn = Faraday.new do |faraday|
          # faraday.response :logger # log requests and responses to $stdout
          faraday.response :follow_redirects # follow redirects
          faraday.response :raise_error # raises an exception if response is a 4xx or 5xx code
          faraday.request :json # encode req bodies as JSON
          faraday.response :json # decode response bodies as JSON
        end

        res = begin
          conn.get('https://rubygems.org/api/v1/search.json', {
                     query: context.q
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

# https://rubygems.org/api/v1/search/autocomplete