# frozen_string_literal: true

class NewsSearchQuery
  include ApplicationInteractor
  include Elasticsearch::DSL

  def call
    definition = search do

      query do
        bool do

          if context.tag.present?
            filter do
              term "tags.keyword" => context.tag
            end
          end

          if context.month.present?
            filter do
              range :published_at do
                gte context.month.beginning_of_month.utc
                lte context.month.end_of_month.utc
              end
            end
          end

          filter do
            term "realm_kind.keyword" => 'news'
          end

          # TODO: replace all searchable term fields with field.keyword
          # term "realm_locale" => "en-US"
          # it doesn't search by "en-US", only by "en"
          filter do
            term "realm_locale.keyword" => context.locale
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
