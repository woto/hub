# frozen_string_literal: true

FactoryBot.define do
  linkedin = Faker::Omniauth.linkedin
  factory :identity do
    uid { linkedin['uid'] }
    provider { linkedin['provider'] }
    auth { linkedin }

    # FIXME: it can't be an identity without user
    trait :with_user do
      association :user, email: linkedin['info']['email']
    end
  end
end
