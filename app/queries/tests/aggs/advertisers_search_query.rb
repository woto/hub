# frozen_string_literal: true
# TODO: remove
class Tests::Aggs::AdvertisersSearchQuery
  include ApplicationInteractor
  include Elasticsearch::DSL

  def call
    definition = search do
      aggregation :advertisers do
        terms do
          field 'feed_category_id'
          size 100
          order "avg_score": "desc"
          aggregation :avg_score do
            avg "script": "_score"
          end
        end
      end

      query do
        bool do
          must do
            multi_match do
              query context.q
              fields ['name.#', 'description.#']
              # fields ['name.#']
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
      h[:size] = 0
    end
  end
end
