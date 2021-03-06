# frozen_string_literal: true
# TODO: remove
class Tests::Aggs::FeedsSearchQuery
  include ApplicationInteractor
  include Elasticsearch::DSL

  def call
    definition = search do
      aggregation :feeds do
        terms do
          field 'feed_id'
          size 10000
        end
      end

      query do
        bool do
          filter do
            term 'advertiser_id' => context.advertiser_id
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
      h[:size] = 0
    end
  end
end
