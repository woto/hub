# frozen_string_literal: true

module Extractors
  module YoutubeCom
    class GetChannelIdFromUrlInteractor
      include ApplicationInteractor

      def call
        uri = URI(context.url)

        result = Net::HTTP.get(uri) # => String

        chunks = result.split('channel_id=')
        context.object = chunks[1][0...24]
      end
    end
  end
end
