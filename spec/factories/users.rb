# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :integer
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
