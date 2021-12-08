# frozen_string_literal: true

module Decorators
  module Mentions
    class Urls
      include ApplicationInteractor

      def call
        context.object = context.object.map do |url|
          {
            image: url.image,
            score: url._score,
            url: url.url,
            title: url.title
          }
        end
      end
    end
  end
end