# frozen_string_literal: true

FactoryBot.define do
  factory :listing, parent: :favorite do
    kind { 'entities' }
  end
end
