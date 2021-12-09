# frozen_string_literal: true

module Elasticable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    # include Elasticsearch::Model::Callbacks

    after_commit lambda {
      send_document_to_elasticsearch if saved_changes?
    }, on: %i[create update]

    after_commit lambda {
      remove_document_from_elasticsearch
    }, on: :destroy

    after_touch lambda {
      send_document_to_elasticsearch
    }

    def send_document_to_elasticsearch
      __elasticsearch__.index_document
      self.class.__elasticsearch__.refresh_index!
    end

    def remove_document_from_elasticsearch
      __elasticsearch__.delete_document
      self.class.__elasticsearch__.refresh_index!
    end

    # after_create lambda { __elasticsearch__.index_document  }
    # after_update lambda { __elasticsearch__.index_document  }
    # after_destroy lambda { __elasticsearch__.delete_document }
  end

  class_methods do
    def setup_index(form_class)
      settings index: {
        number_of_shards: 1,
        analysis: {
          "analyzer": {
            "custom_edge_ngram_analyzer_v2_0_2": {
              "type": 'custom',
              "tokenizer": 'customized_edge_tokenizer_v2_0_2',
              "filter": %w[lowercase]
            }
          },
          "tokenizer": {
            "customized_edge_tokenizer_v2_0_2": {
              "type": 'edge_ngram',
              "min_gram": 2,
              "max_gram": 2048,
              "token_chars": %w[
                letter
                digit
              ]
            }
          }
        }
      } do
        mapping dynamic: 'true' do
          form_class.all_columns.each do |column|
            es = form_class.elastic_column(column[:key])

            if es[:sort]
              indexes column[:key],
                      type: es[:type],
                      fields: {
                        keyword: {
                          ignore_above: 256,
                          type: 'keyword'
                        },
                        autocomplete: {
                          type: 'text',
                          analyzer: 'custom_edge_ngram_analyzer_v2_0_2'
                        }
                      }
            else
              indexes column[:key], type: es[:type]
            end
          end
        end
      end
    end
  end
end
