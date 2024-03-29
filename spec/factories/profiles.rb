# frozen_string_literal: true

# == Schema Information
#
# Table name: profiles
#
#  id         :bigint           not null, primary key
#  bio        :text
#  languages  :jsonb
#  messengers :jsonb
#  name       :string
#  time_zone  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :profile do
    user
    name { Faker::Name.name }
    bio { Faker::Hipster.sentence }
    messengers do
      [
        # TODO: Rails.application.config.global[:messengers].map { |msn| msn[:long] }
        { type: 'whatsapp', value: Faker::PhoneNumber.phone_number_with_country_code },
        { type: 'telegram', value: Faker::PhoneNumber.phone_number_with_country_code }
      ]
    end
    languages { I18n.available_locales.sample(rand(2)) }
    time_zone { ActiveSupport::TimeZone.all.sample.name }
  end
end
