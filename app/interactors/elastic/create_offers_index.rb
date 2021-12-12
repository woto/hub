# frozen_string_literal: true

module Elastic
  class CreateOffersIndex
    include ApplicationInteractor

    def call
      GlobalHelper.elastic_client.indices.create index: Elastic::IndexName.pick('offers').scoped, body: {
        "settings": {
          "index": {
            "refresh_interval": -1,
            "number_of_shards": 10,
            "number_of_replicas": 1
          }

          # "analysis": {
          #   "filter": {
          #     "russian_stop": {
          #       "type": 'stop',
          #       "stopwords": '_russian_'
          #     },
          #     "russian_keywords": {
          #       "type": 'keyword_marker',
          #       "keywords": ['пример']
          #     },
          #     "russian_stemmer": {
          #       "type": 'stemmer',
          #       "language": 'russian'
          #     }
          #   },
          #   "analyzer": {
          #     "default": {
          #       "tokenizer": 'standard',
          #       "filter": %w[
          #         lowercase
          #         russian_stop
          #         russian_keywords
          #         russian_stemmer
          #       ]
          #     }
          #   }
          # }
        }
      }
    end
  end
end
