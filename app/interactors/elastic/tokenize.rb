# frozen_string_literal: true

# # frozen_string_literal: true
#
module Elastic
  class Tokenize
    include ApplicationInteractor

    def call
      client = Elasticsearch::Client.new Rails.application.config.elastic

      index_name = 'russian_english_tokenizer'
      client.indices.delete index: index_name, ignore_unavailable: true
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

      result = client.indices.analyze(
        index: index_name,
        body: {
          analyzer: 'default',
          text: context.q
        }
      )
      context.object = result['tokens'].map { |t| t['token'] }
    end
  end
end
