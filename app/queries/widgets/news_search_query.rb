# frozen_string_literal: true

class Widgets::NewsSearchQuery
  include ApplicationInteractor
  include Elasticsearch::DSL

  def call
    definition = search do

      explain(true) if context.explain.present?

      query do
        bool do

          filter do
            term "realm_kind" => 'news'
          end

          filter do
            term "realm_locale" => context.locale
          end

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
      h[:index] = ::Elastic::IndexName.posts
      h[:from] = context.from
      h[:size] = context.size
      h[:_source] = context._source
    end
  end
end
