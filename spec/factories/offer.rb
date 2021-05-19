# frozen_string_literal: true

FactoryBot.define do
  factory :offer, class: Hash do
    transient do
      refresh { true }
    end

    _id { nil }

    to_create do |instance, evaluator|
      result = GlobalHelper.elastic_client.index(
        id: instance['_id'],
        body: instance.without('_id'),
        routing: instance['feed_id'],
        refresh: evaluator.refresh,
        index: Elastic::IndexName.offers
      )
      instance['_id'] ||= result['_id']
    end

    initialize_with { attributes.stringify_keys }
  end
end
