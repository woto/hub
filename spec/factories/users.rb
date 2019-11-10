FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    confirmed_at { Time.now.utc }

    trait(:unconfirmed) {
      confirmed_at { nil }
    }

    trait(:without_email_and_password) {
      unconfirmed
      email { nil }
      password { nil }
    }
  end
end
