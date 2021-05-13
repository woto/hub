# == Schema Information
#
# Table name: accounts
#
#  id               :bigint           not null, primary key
#  amount           :decimal(, )      default(0.0), not null
#  code             :integer          not null
#  currency         :integer          not null
#  subjectable_type :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  subjectable_id   :bigint           not null
#
# Indexes
#
#  account_set_uniqueness                                 (code,currency,subjectable_id,subjectable_type) UNIQUE
#  index_accounts_on_subjectable_type_and_subjectable_id  (subjectable_type,subjectable_id)
#
FactoryBot.define do
  factory :account do
    code { Account.codes.keys.sample }
    currency { Rails.configuration.available_currencies.sample }

    for_user

    trait :for_user do
      association :subjectable, factory: :user
    end

    trait :for_hub do
      association :subjectable, factory: :subject, identifier: :hub
    end
  end
end
