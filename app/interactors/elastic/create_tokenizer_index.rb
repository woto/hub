# frozen_string_literal: true

module Elastic
  class CreateTokenizerIndex
    include ApplicationInteractor

    def call
      client = Elasticsearch::Client.new Rails.application.config.elastic
      index_name = Elastic::IndexName.tokenizer

      Elastic::DeleteIndex(index_name: index_name, ignore_unavailable: true)

      client.indices.create index: index_name, body: {
        settings: {
          analysis: {
            filter: {
              russian_stop: {
                type: 'stop',
                stopwords: '_russian_'
              },
              english_stop: {
                type: 'stop',
                stopwords: '_english_'
              }
            },
            analyzer: {
              default: {
                tokenizer: 'standard',
                filter: %i[
                  lowercase
                  russian_stop
                  english_stop
                ]
              }
            }
          }
        }
      }
    end
  end
end
