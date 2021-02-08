# frozen_string_literal: true

class OffersSearchQuery
  include ApplicationInteractor
  include Elasticsearch::DSL

  # Code fully covered by tests in spec/lib/queries/offers_search_query_spec.rb
  def call
    search_tokens = Elastic::Tokenize.call(q: context.q).object
    search_string = search_tokens.join(' ')

    body = Jbuilder.encode do |json|
      json.aggs do
        json.vendors do
          json.terms do
            json.field 'vendor.#.keyword'
            json.size 30
          end
        end
      end

      # TODO prices
      #
      # json.aggs do
      #   json.max_price do
      #     json.max do
      #       json.field 'price.#.keyword'
      #     end
      #   end
      # end
      #
      # json.aggs do
      #   json.min_price do
      #     json.min do
      #       json.field 'price.#.keyword'
      #     end
      #   end
      # end

      json.aggs do
        json.group do
          json.terms do
            json.field context.group_by
            json.order do
              json.set! 'sort.sum_of_squares', 'desc'
            end
            json.size 1000
          end
          json.aggs do
            json.offers do
              json.top_hits do
                json.size 6
              end
            end
            json.sort do
              json.extended_stats do
                json.script do
                  json.source '_score'
                end
              end
            end
          end
        end
      end

      json.query do
        json.bool do

          if context.advertiser_id.present?
            json.set! :filter do
              json.array! ['fuck'] do
                json.term do
                  json.advertiser_id context.advertiser_id
                end
              end
            end
          elsif context.feed_id.present?
            json.set! :filter do
              json.array! ['fuck'] do
                json.term do
                  json.feed_id context.feed_id
                end
              end
            end
          elsif context.feed_category_id
            json.set! :filter do
              json.array! ['fuck'] do
                json.term do
                  # TODO
                  # if context.only
                  #   term Feeds::Offers::CATEGORY_ID_KEY => context.category_id
                  json.set! "#{Feeds::Offers::CATEGORY_ID_KEY}_#{context.current_category_level}", context.feed_category_id
                end
              end
            end
          end

          json.set! :should do
            json.array! ['fuck'] do
              json.multi_match do
                json.query search_string
                json.fields %w[name.#^3 feed_category_name.# description.#]
              end
            end
          end

          json.set! :filter do
            json.array! ['fuck'] do
              json.multi_match do
                json.query search_string
                json.fields %w[name.# feed_category_name.# description.#]
                json.fuzziness 'auto'
                json.minimum_should_match search_tokens.count
              end
            end
          end

        end
      end
    end

    context.object = {}.tap do |h|
      h[:body] = body
      h[:index] = ::Elastic::IndexName.offers
      h[:from] = context.from
      h[:size] = 0
      h[:routing] = context.feed_id if context.feed_id.present?
    end
  end
end
