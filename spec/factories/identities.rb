FactoryBot.define do
  factory :identity do
    transient do
      social { Faker::Omniauth.google }
    end
    uid { social['uid'] }
    provider { social['provider'] }
    auth { social }
    user
  end
end
