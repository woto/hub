# frozen_string_literal: true

module Mentions
  class UrlsInteractor
    include ApplicationInteractor
    include ActionView::Helpers

    def call
      raise 'Mentions::UrlsInteractor'

      # body = {
      #   query: {
      #     match: {
      #       url: {
      #         "query": context.q,
      #         "fuzziness": 'AUTO',
      #         "fuzzy_transpositions": true,
      #         "operator": 'or',
      #         "minimum_should_match": 1,
      #         "zero_terms_query": 'none',
      #         "lenient": false,
      #         "prefix_length": 0,
      #         "max_expansions": 50,
      #         "boost": 1
      #       }
      #     }
      #   },
      #   size: 5
      # }
      #
      # context.object = Mention.__elasticsearch__.search(body)
    end
  end
end
