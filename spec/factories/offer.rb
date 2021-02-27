# frozen_string_literal: true

FactoryBot.define do
  factory :offer, class: Hash do
    indexed_at { Time.current }

    # transient do
    #   feed do
    #     association :feed
    #   end
    # end

    to_create do |instance, evaluator|
      client = Elasticsearch::Client.new(Rails.application.config.elastic)
      client.index(
        body: instance,
        # routing: evaluator.feed.id,
        routing: instance[:feed_id],
        refresh: true,
        index: Elastic::IndexName.offers
      )
    end

    initialize_with { attributes.stringify_keys }
  end
end
