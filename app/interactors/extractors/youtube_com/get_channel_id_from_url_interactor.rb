# frozen_string_literal: true

module Extractors
  module YoutubeCom
    class GetChannelIdFromUrlInteractor
      include ApplicationInteractor

      def call
        conn = Faraday.new do |faraday|
          faraday.request :retry # retry transient failures
          faraday.response :follow_redirects # follow redirects
          faraday.response :raise_error # raises an exception if response is a 4xx or 5xx code
        end
        result = conn.get(context.url)

        chunks = result.body.split('channel_id=')
        context.object = chunks[1][0...24]
      end
    end
  end
end
