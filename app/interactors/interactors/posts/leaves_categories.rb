# frozen_string_literal: true

module Interactors
  module Posts
    class LeavesCategories
      include ApplicationInteractor

      def call
        body = Jbuilder.new do |json|
          json.query do
            json.bool do
              json.must do
                json.multi_match do
                  json.query context.q
                  json.type 'bool_prefix'
                  json.fields do
                    json.array! %w[
                      title.autocomplete^2
                      title.autocomplete._2gram^2
                      title.autocomplete._3gram^2
                      path.autocomplete
                      path.autocomplete._2gram
                      path.autocomplete._3gram
                    ]
                  end
                end
              end
              json.filter do
                json.array! ['fuck'] do
                  json.term do
                    json.leaf true
                  end
                end
                json.array! ['fuck'] do
                  json.term do
                    json.realm_id context.realm_id
                  end
                end
              end
            end
          end
          json.size 30
          json.from 0
          json._source %w[id path title]
        end

        query = body.attributes!.deep_symbolize_keys
        categories = PostCategory.__elasticsearch__.search(query)

        context.object = categories.map do |category|
          {
            id: category.id,
            path: category.path.join(' > '),
            title: category.title
          }
        end
      end
    end
  end
end
