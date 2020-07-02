# frozen_string_literal: true

# == Schema Information
#
# Table name: profiles
#
#  id         :bigint           not null, primary key
#  name       :string
#  bio        :text
#  location   :string
#  messengers :jsonb
#  languages  :jsonb
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
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
    languages { %w[russian english spanish french].sample(rand(1..4)) }
    user
  end
end
