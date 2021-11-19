# frozen_string_literal: true

module Interactors
  module Mentions
    class Urls
      include ApplicationInteractor
      include ActionView::Helpers

      def call
        body = {
          query: {
            match: {
              url: {
                "query": context.q,
                "fuzziness": 'AUTO',
                "fuzzy_transpositions": true,
                "operator": 'or',
                "minimum_should_match": 1,
                "zero_terms_query": 'none',
                "lenient": false,
                "prefix_length": 0,
                "max_expansions": 50,
                "boost": 1
              }
            }
          },
          size: 5
        }

        urls = Mention.__elasticsearch__.search(body)

        context.object = urls.map do |url|
          {
            image: url.image,
            score: url._score,
            url: url.url
          }
        end
      end
    end
  end
end
