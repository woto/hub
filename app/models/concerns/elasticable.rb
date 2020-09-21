# frozen_string_literal: true

module Elasticable
  extend ActiveSupport::Concern

  RAILS2ES = {
      string: { es_type: :text, sort: '.keyword' },
      integer: { es_type: :long, sort: '' },
      uuid: { es_type: :text, sort: '.keyword' },
      text: { es_type: :text, sort: false },
      boolean: { es_type: :boolean, sort: '' },
      datetime: { es_type: :date, sort: '' }
  }.freeze

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    model_class = self

    mapping dynamic: 'true' do
      model_class.columns.each do |column|
        case column.type
        when *RAILS2ES.keys
          # debugger
          indexes column.name, type: RAILS2ES[column.type][:es_type], fields: {
            keyword: {
              ignore_above: 256,
              type: 'keyword'
            },
            autocomplete: {
              type: 'search_as_you_type'
            }
          }
        end
      end
    end
  end

  class_methods do
    # ...
  end
end
