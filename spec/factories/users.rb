# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    confirmed_at { Time.now.utc }

    trait(:unconfirmed) do
      confirmed_at { nil }
    end

    trait(:with_profile) do
      after(:create) do |user|
        create(:profile, user: user)
      end
    end
  end
end
