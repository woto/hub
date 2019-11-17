# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    name { Faker::Name.name }
    bio { Faker::Hipster.sentence }
    location { Faker::Address.full_address }
    messengers do
      [
        { name: 'whatsapp', number: Faker::PhoneNumber.phone_number_with_country_code },
        { name: 'telegram', number: Faker::PhoneNumber.phone_number_with_country_code }
      ]
    end
    languages { ['russian', 'english', 'spanish', 'french'].sample(rand(1..4)) }
    user
  end
end
