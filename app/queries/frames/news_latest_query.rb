# frozen_string_literal: true

module Frames
  class NewsLatestQuery
    include ApplicationInteractor
    include Elasticsearch::DSL

    def call
      definition = search do

        query do
          bool do
            filter do
              term 'realm_kind' => 'news'
            end

            filter do
              term 'realm_locale.keyword' => context.locale
            end

            filter do
              range :published_at do
                lte Time.current.utc
              end
            end

            filter do
              match_all {}
            end
          end
        end

        sort do
          by :published_at, order: :desc
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
end
