# frozen_string_literal: true

class ArticlesSearchQuery
  include ApplicationInteractor
  include Elasticsearch::DSL

  def call
    definition = search do
      query do
        bool do
          filter do
            term 'realm_id.keyword' => Current.realm.id
          end

          filter do
            term 'status.keyword' => 'accrued_post'
          end

          filter do
            range :published_at do
              lte Time.current.utc
            end
          end

          if context.tag.present?
            filter do
              term 'tags.keyword' => context.tag
            end
          end

          if context.post_category_id.present?
            post_category = PostCategory.find(context.post_category_id)
            filter do
              term "post_category_id_#{post_category.ancestry_depth}" => context.post_category_id.to_i
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
