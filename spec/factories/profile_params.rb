# frozen_string_literal: true

FactoryBot.define do
  factory :profile_params, class: Hash do
    skip_create
    initialize_with { attributes.stringify_keys }

    name { Faker::Name.name }
    bio { Faker::Hipster.sentence }
    messengers do
      Rails.application.config.global[:messengers].sample(2).map do |messenger|
        { type: messenger[:long], value: Faker::PhoneNumber.phone_number_with_country_code }
      end
    end
    avatar { ShrineImage.image_data }
    languages { I18n.available_locales.sample(rand(3)).map(&:to_s) }
    time_zone { ActiveSupport::TimeZone.all.sample.name }
  end
end
