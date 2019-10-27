# frozen_string_literal: true

module Staff
  module Seeder
    # Elastic first simple seeder used for tests
    class Elastic
      class << self
        MY_INDEX_NAME = 'my_index_name'
        MY_OFFER_NAME = 'my_offer_name'
        MY_INDEX_SIZE = 21
        FEEDS_SIZE = 21
        OFFERS_SIZE = 1

        def pagination
          client = Elasticsearch::Client.new Rails.application.config.elastic
          bulk_array = []
          document_id = 0
          indexes_count = 0

          loop do
            index_name = if indexes_count.zero?
                           MY_INDEX_NAME
                         else
                           Faker::Company.name.parameterize.underscore
                         end
            index_name = ::Elastic::IndexName.offers(index_name)
            offers_count = 0
            loop do
              document_id += 1
              bulk_array << {
                index: offer(indexes_count,
                             index_name,
                             offers_count,
                             Faker::Commerce.product_name.parameterize.underscore,
                             document_id)
              }
              offers_count += 1
              break if offers_count > (OFFERS_SIZE - 1)
            end
            indexes_count += 1
            break if indexes_count > (FEEDS_SIZE - 1)
          end

          offers_count = 1
          loop do
            document_id += 1
            bulk_array << {
              index: offer(0,
                           ::Elastic::IndexName.offers(MY_INDEX_NAME),
                           offers_count,
                           MY_OFFER_NAME,
                           document_id)
            }
            offers_count += 1
            break if offers_count > (MY_INDEX_SIZE - 1)
          end

          client.bulk(body: bulk_array.as_json)
          client.indices.refresh
        end

        def offer(index_index, index_name, offer_index, offer_name, document_id)
          OffersBulkStruct.new(
            _index: "#{index_index.to_words}_#{index_name}",
            _id: document_id.to_s,
            data: OfferStruct.new(
              name: "[#{offer_index.to_words}] [#{offer_name}] #{offer_index.to_words}_#{offer_name}",
              price: Faker::Commerce.price,
              currencyId: %w[RUR EUR USD].sample,
              url: Faker::Internet.url,
              picture: rand(5).times.map do
                "https://nv6.ru/dummy.jpeg"
              end
            )
          )
        end
      end
    end
  end
end
