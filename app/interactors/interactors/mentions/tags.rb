# frozen_string_literal: true

module Interactors
  module Mentions
    class Tags
      include ApplicationInteractor

      contract do
        params do
          config.validate_keys = true
          required(:q).maybe(:string)
          required(:limit).maybe(:integer)
          required(:sort).maybe(:string)
          required(:order).maybe(:string)
        end
      end

      def call
        # fields: %w[title.autocomplete title.autocomplete._2gram title.autocomplete._3gram]
        body = Jbuilder.new do |json|
          json.query do
            if context.q.present?
              json.bool do
                json.must do
                  json.multi_match do
                    json.query context.q
                    json.type 'bool_prefix'
                    json.fields do
                      json.array! %w[
                        title.autocomplete
                        title.autocomplete._2gram
                        title.autocomplete._3gram
                      ]
                    end
                  end
                end
              end
            end
          end
          json.size context.limit
          json.from 0

          json.sort do
            json.array! ['fuck'] do
              json.set! context.sort do
                json.order context.order
              end
            end
          end
          # json._source %w[id title]
        end

        query = body.attributes!.deep_symbolize_keys
        topics = Topic.__elasticsearch__.search(query)

        context.object = topics.map do |topic|
          {
            title: topic['_source']['title'],
          }
        end
      end
    end
  end
end
