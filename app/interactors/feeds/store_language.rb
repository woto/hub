# frozen_string_literal: true

# require 'elasticsearch/dsl'

class Feeds::StoreLanguage
  include Elasticsearch::DSL::Search
  include ApplicationInteractor

  def call
    client = Elasticsearch::Client.new Rails.application.config.elastic

    indices = client.cat.indices(
      format: 'json',
      index: Elastic::IndexName.all_offers
    )

    indices.each do |index|
      definition = search do
        size 0
        aggregation :language do
          terms do
            field "#{Feeds::Offers::LANGUAGE_KEY}.name.keyword"
            size 1
          end
        end
      end

      index_name = index['index']

      resp = client.search body: definition, index: index_name
      begin
        feed = Feed.find_by!(index_name: Elastic::IndexName.offers_crop(index_name))
        bucket = resp['aggregations']['language']['buckets'].first
        if bucket
          feed.update!(operation: 'language', language: resp && bucket['key'])
        end
      rescue StandardError => e
        debugger
        p 1
      end
    end
  end
end
