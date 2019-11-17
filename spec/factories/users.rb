# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    confirmed_at { Time.now.utc }

    trait(:unconfirmed) do
      confirmed_at { nil }
    end

    trait(:with_identity) do
      unconfirmed
      email { nil }
      password { nil }
      oauthenticable { true }

      identities do
        auth = Faker::Omniauth.google
        build_list :identity, 1, auth: auth, provider: auth[:provider],
                                 uid: auth[:uid]
      end
    end

    trait(:with_profile) do
      after(:create) do |user|
        create(:profile, user: user)
      end
    end

    trait(:with_avatar) do
      after(:create) do |user|
        user.avatar.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'avatar.png')), filename: 'avatar.png')
      end
    end
  end
end
