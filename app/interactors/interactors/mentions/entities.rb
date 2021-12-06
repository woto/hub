# frozen_string_literal: true

module Interactors
  module Mentions
    class Entities
      include ApplicationInteractor

      def call
        body = Jbuilder.new do |json|
          json.query do
            json.bool do
              json.filter do
                json.multi_match do
                  json.query context.q
                  json.type 'bool_prefix'
                  json.fields do
                    json.array! %w[
                      title
                      title.autocomplete
                      title.autocomplete._2gram
                      title.autocomplete._3gram
                      lookups
                      lookups.autocomplete
                      lookups.autocomplete._2gram
                      lookups.autocomplete._3gram
                    ]
                  end
                end
              end
            end
          end
        end

        query = body.attributes!.deep_symbolize_keys
        context.object = Entity.__elasticsearch__.search(query).page(context.page).limit(context.limit)
      end
    end
  end
end
