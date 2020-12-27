# frozen_string_literal: true

module Elasticable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    # include Elasticsearch::Model::Callbacks

    after_commit lambda {
      __elasticsearch__.index_document
      self.class.__elasticsearch__.refresh_index!
    }, on: [:create, :update]

    after_commit lambda {
      __elasticsearch__.delete_document
      self.class.__elasticsearch__.refresh_index!
    }, on: :destroy

    # after_create lambda { __elasticsearch__.index_document  }
    # after_update lambda { __elasticsearch__.index_document  }
    # after_destroy lambda { __elasticsearch__.delete_document }
  end

  class_methods do
    def setup_index(form_class)
      settings index: { number_of_shards: 1 } do
        mapping dynamic: 'true' do
          form_class.all_columns.each do |column|
            es = form_class.elastic_column(column[:key])

            if es[:sort]
              indexes column[:key], type: es[:type], fields: {
                keyword: {
                  ignore_above: 256,
                  type: 'keyword'
                },
                autocomplete: {
                  type: 'search_as_you_type'
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
