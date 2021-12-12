# frozen_string_literal: true

module Elastic
  class CreateTokenizerIndex
    include ApplicationInteractor

    def call
      index = Elastic::IndexName.pick('tokenizer')

      Elastic::DeleteIndex.call(index: index, ignore_unavailable: true)

      GlobalHelper.elastic_client.indices.create index: index.scoped, body: {
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
