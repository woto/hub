# frozen_string_literal: true

module Frames
  class NewsByMonthSearchQuery
    include ApplicationInteractor
    include Elasticsearch::DSL

    def call
      definition = search do
        aggregation :group_by_month do
          date_histogram do
            field 'published_at'
            interval 'month'
            order(_key: 'desc')
            # time_zone Time.zone.formatted_offset
          end
        end

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

            # if context.q.present?
            #   must do
            #     query_string do
            #       query context.q
            #     end
            #   end
            # else
            #   filter do
            #     match_all {}
            #   end
            # end
          end
        end

        # sort do
        #   by context.sort, order: context.order
        # end
      end

      context.object = {}.tap do |h|
        h[:body] = definition.to_hash.deep_symbolize_keys
        h[:index] = ::Elastic::IndexName.posts
        # h[:from] = context.from
        h[:size] = 0
        h[:_source] = context._source
      end
    end
  end
end
