# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  api_key                :string
#  checks_count           :integer          default(0), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  favorites_count        :integer          default(0), not null
#  identities_count       :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  locked_at              :datetime
#  mentions_count         :integer          default(0), not null
#  posts_count            :integer          default(0), not null
#  profiles_count         :integer          default(0), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("user"), not null
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  workspaces_count       :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_api_key               (api_key) UNIQUE
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    confirmed_at { Time.now.utc }

    trait(:unconfirmed) do
      confirmed_at { nil }
    end

    trait(:with_identity) do
      unconfirmed
      email { nil }
      password { nil }

      # TODO: may be should be rewritten with hooks (callbacks)
      identities do
        auth = Faker::Omniauth.google
        build_list :identity, 1, auth: auth, provider: auth[:provider], uid: auth[:uid]
      end
    end

    trait(:with_profile) do
      after(:create) do |user|
        create(:profile, user: user)
      end
    end

    trait(:with_avatar) do
      after(:create) do |user|
        user.avatar.attach(io: File.open(Rails.root.join('spec/fixtures/files/avatar.png')), filename: 'avatar.png')
      end
    end
  end
end
