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
    name { Faker::Name.name }
    bio { Faker::Hipster.sentence }
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
