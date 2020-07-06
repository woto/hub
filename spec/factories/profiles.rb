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
        # TODO: Rails.application.config.global[:messengers].map { |msn| msn[:long] }
        { type: 'whatsapp', value: Faker::PhoneNumber.phone_number_with_country_code },
        { type: 'telegram', value: Faker::PhoneNumber.phone_number_with_country_code }
      ]
    end
    # TODO:
    languages { %w[Russian English Spanish French].sample(rand(1..4)) }
    user
  end
end
