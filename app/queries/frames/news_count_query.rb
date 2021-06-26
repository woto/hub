# frozen_string_literal: true

module Frames
  class NewsCountQuery
    include ApplicationInteractor
    include Elasticsearch::DSL

    def call
      definition = search do

        query do
          bool do
            filter do
              term 'realm_kind.keyword' => 'news'
            end

            filter do
              term 'status.keyword' => 'accrued_post'
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
      end

      context.object = {}.tap do |h|
        h[:body] = definition.to_hash.deep_symbolize_keys
        h[:index] = ::Elastic::IndexName.posts
      end
    end
  end
end
