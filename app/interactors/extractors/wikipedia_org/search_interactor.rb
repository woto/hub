# frozen_string_literal: true

module Extractors
  module WikipediaOrg
    class SearchInteractor
      include ApplicationInteractor
      include Rails.application.routes.url_helpers

      def call
        conn = Faraday.new do |faraday|
          # faraday.response :logger # log requests and responses to $stdout
          faraday.response :follow_redirects # follow redirects
          faraday.response :raise_error # raises an exception if response is a 4xx or 5xx code
          faraday.request :json # encode req bodies as JSON
          faraday.response :json # decode response bodies as JSON
        end

        page_language = case context.page_language
                        when 'und'
                          'ru'
                        else
                          context.page_language
                        end

        res = begin
          conn.get("https://api.wikimedia.org/core/v1/wikipedia/#{page_language}/search/page", {
                     q: context.q,
                     limit: 10
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
