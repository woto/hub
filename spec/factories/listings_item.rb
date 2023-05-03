# frozen_string_literal: true

FactoryBot.define do
  factory :listings_item, parent: :favorites_item do
    kind { 'entities' }
  end
end
