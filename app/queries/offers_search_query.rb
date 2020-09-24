# frozen_string_literal: true

class OffersSearchQuery
  include ApplicationInteractor
  include Elasticsearch::DSL

  # Code fully covered by tests in spec/lib/queries/offers_search_query_spec.rb
  def call
    level = if context.category_id.present?
              FeedCategory.find(context.category_id).ancestry_depth
            else
              -1
            end

    definition = search do
      highlight do
        tags_schema :styled
        fields %w[description.# name.#]
      end

      explain(true) if context.explain.present?

      if context.feed_id.blank?
        aggregation :feeds do
          terms do
            field '_index'
            size 20
          end
        end
      else
        aggregation :categories do
          terms do
            field "category_level_#{level + 1}"
            size 20
          end
        end
        if context.category_id.present?
          aggregation :category do
            filter term: { feed_category_id: context.category_id }
          end
        end
      end

      query do
        bool do
          if context.category_id.present?
            filter do
              if context.only
                term 'feed_category_id' => context.category_id
              else
                term "category_level_#{level}" => context.category_id
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

      # TODO. Optimize (cache? remove randomness?)
      if context.feed_id.blank? && context.category_id.blank? && context.q.blank?
        sort do
          by Feeds::Offers::INDEXED_AT, order: :desc
        end
      end
    end

    context.object = {
      body: definition.to_hash.deep_symbolize_keys,
      index: ::Elastic::IndexName.offers(context.feed_id.presence || '*')
    }
  end
end
