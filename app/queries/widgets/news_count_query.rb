# frozen_string_literal: true

module Widgets
  class NewsCountQuery
    include ApplicationInteractor
    include Elasticsearch::DSL

    def call
      definition = search do
        explain(true) if context.explain.present?

        query do
          bool do
            filter do
              term 'realm_kind' => 'news'
            end

            filter do
              term 'realm_locale.keyword' => context.locale
            end

            filter do
              match_all {}
            end
          end
        end
      end

      context.object = {}.tap do |h|
        h[:body] = definition.to_hash.deep_symbolize_keys
        h[:index] = ::Elastic::IndexName.posts
      end
    end
  end
end
