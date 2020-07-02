# frozen_string_literal: true

# == Schema Information
#
# Table name: identities
#
#  id         :bigint           not null, primary key
#  uid        :string           not null
#  provider   :string           not null
#  user_id    :bigint           not null
#  auth       :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
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
