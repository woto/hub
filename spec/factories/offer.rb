# frozen_string_literal: true

FactoryBot.define do
  factory :offer, class: Hash do
    to_create do |instance, _evaluator|
      client = Elasticsearch::Client.new(Rails.application.config.elastic)
      client.index(
        body: instance,
        routing: instance['feed_id'],
        refresh: true,
        index: Elastic::IndexName.offers
      )
    end

    initialize_with { attributes.stringify_keys }
  end
end
