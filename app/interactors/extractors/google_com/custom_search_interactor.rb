# frozen_string_literal: true

module Extractors
  module GoogleCom
    class CustomSearchInteractor
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

        res = begin
          conn.get('https://content-customsearch.googleapis.com/customsearch/v1', {
                     q: context.q,
                     cx: ENV.fetch('GOOGLE_CUSTOM_SEARCH_CX_KEY'),
                     key: ENV.fetch('GOOGLE_CUSTOM_SEARCH_API_KEY')
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
