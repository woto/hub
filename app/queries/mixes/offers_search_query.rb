# frozen_string_literal: true

class Mixes::OffersSearchQuery
  include ApplicationInteractor
  include Elasticsearch::DSL

  # Code fully covered by tests in spec/lib/queries/offers_search_query_spec.rb
  def call
    # if context.q.present?
    #   filter = Stopwords::Snowball::Filter.new "ru"
    #   splitted_query = filter.filter(context.q.split(' '))
    #   words_count = splitted_query.count
    #   context.q = splitted_query.join(' ')
    # end

    level = if context.category_id.present?
              FeedCategory.find(context.category_id).ancestry_depth
            else
              -1
            end

    definition = search do
      highlight do
        tags_schema :styled
        fields %w[description.# name.#  ]
      end

      explain(true) if context.explain.present?

      # terms do
      #   field 'vendor.#.keyword'
      #   size 50
      # end

      query do
        bool do

          if context.q.present?

            # should do
            #   match 'name.#' do
            #     query context.q
            #   end
            #   boost 10
            # end

            should do
              multi_match do
                query context.q
                fields ['name.#^3', Feeds::Offers::CATEGORY_NAMES_KEY, 'description.#']
                # minimum_should_match "90%"
                # cutoff_frequency 0.001
                # max_expansions 10
                # prefix_length 5
                # minimum_should_match "3"
                # operator "AND"
                # fuzziness "AUTO"
                # boost 5
              end
            end

            must do
              multi_match do
                query context.q
                # fields ['name.#']
                fields ['name.#^3', "#{Feeds::Offers::CATEGORY_NAME_KEY}^1", 'description.#']
                type "most_fields"
                fuzziness "AUTO"
                minimum_should_match context.q.split("\s").count
              end
            end

            # minimum_should_match "90%"

          else
            filter do
              match_all {}
            end
          end
        end
      end

      # collapse 'description.#.keyword'

      # collapse Feeds::Offers::CATEGORY_ID_KEY do
      collapse "advertiser_id" do
        inner_hits 'offers' do
          size 10
          # TODO: finish pull request
          # https://github.com/elastic/elasticsearch-ruby/pull/1180
          highlight do
            tags_schema :styled
            fields %w[description.# name.#]
          end
        end
      end

      # # TODO. Optimize (cache? remove randomness?)
      # if context.feed_id.blank? && context.category_id.blank? && context.q.blank?
      #   sort do
      #     by Feeds::Offers::INDEXED_AT, order: :desc
      #   end
      # end
    end

    context.object = {}.tap do |h|
      h[:body] = definition.to_hash.deep_symbolize_keys
      h[:index] = ::Elastic::IndexName.offers
      h[:from] = context.from
      h[:size] = context.size
      h[:routing] = context.feed_id if context.feed_id.present?
    end
  end
end
