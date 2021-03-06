# frozen_string_literal: true
# TODO: remove
class Tests::Aggs::FeedCategoriesSearchQuery
  include ApplicationInteractor
  include Elasticsearch::DSL

  def call
    definition = search do
      aggregation :aaa do
        terms do
          # field 'feed_category_id'
          field 'category_level_0'
          size 100

          aggregation :ccc do
            terms do
              field 'category_level_1'
              size 100
            end
          end
        end
      end

      # collapse "category_level_0" do
      collapse "feed_category_id" do
        inner_hits :bbb do
          size 2
        end
      end
      #   collapse :user
      #     inner_hits 'last_tweet' do
      #       size 10
      #       from 5
      #       sort do
      #         by :date, order: 'desc'
      #         by :likes, order: 'asc'
      #       end
      #     end
      #   end


      query do
        bool do

          filter do
            term 'feed_id' => context.feed_id
          end

          must do
            multi_match do
              query context.q
              fields ['name.#', 'description.#']
              operator "AND"
              fuzziness "AUTO"
            end
          end

        end
      end
    end

    context.object = {}.tap do |h|
      h[:body] = definition.to_hash.deep_symbolize_keys
      h[:index] = ::Elastic::IndexName.offers
      h[:size] = 50
    end
  end
end
