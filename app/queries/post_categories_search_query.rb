# frozen_string_literal: true

class PostCategoriesSearchQuery
  include ApplicationInteractor
  include Elasticsearch::DSL

  def call
    definition = search do

      query do
        bool do
          if context.q.present?
            must do
              query_string do
                query context.q
              end
            end
          else
            filter do
              match_all {}
            end
          end
        end
      end

      sort do
        by context.sort, order: context.order
      end
    end

    context.object = {}.tap do |h|
      h[:body] = definition.to_hash.deep_symbolize_keys
      h[:index] = ::Elastic::IndexName.post_categories
      h[:from] = context.from
      h[:size] = context.size
      h[:_source] = context._source
    end
  end
end
