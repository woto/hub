# frozen_string_literal: true

module Elastic
  class CreateIndex
    include ApplicationInteractor

    def call
      index_name = Elastic::IndexName.offers(context.feed.slug)
      client = Elasticsearch::Client.new Rails.application.config.elastic
      client.indices.create index: index_name, body: {
        "settings": {
          "analysis": {
            "filter": {
              "russian_stop": {
                "type": 'stop',
                "stopwords": '_russian_'
              },
              "russian_keywords": {
                "type": 'keyword_marker',
                "keywords": ['пример']
              },
              "russian_stemmer": {
                "type": 'stemmer',
                "language": 'russian'
              }
            },
            "analyzer": {
              "default": {
                "tokenizer": 'standard',
                "filter": %w[
                  lowercase
                  russian_stop
                  russian_keywords
                  russian_stemmer
                ]
              }
            }
          }
        }
      }
    end
  end
end
