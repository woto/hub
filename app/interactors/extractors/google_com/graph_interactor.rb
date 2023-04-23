# frozen_string_literal: true


# https://developers.google.com/knowledge-graph/reference/rest/v1
# https://developers.google.com/knowledge-graph

module Extractors
  module GoogleCom
    class GraphInteractor
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
          conn.get('https://kgsearch.googleapis.com/v1/entities:search', {
                     query: context.q,
                     key: ENV.fetch('GOOGLE_GRAPH_KEY'),
                     limit: 10,
                     indent: true,
                     'languages': 'en',
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
