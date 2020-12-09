# == Schema Information
#
# Table name: accounts
#
#  id           :bigint           not null, primary key
#  amount       :decimal(, )      default(0.0), not null
#  code         :integer          not null
#  comment      :string           not null
#  currency     :integer          not null
#  identifier   :uuid
#  kind         :integer          not null
#  subject_type :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  subject_id   :bigint           not null
#
# Indexes
#
#  account_set_uniqueness                         (identifier,kind,currency,subject_id,subject_type) UNIQUE
#  index_accounts_on_subject_type_and_subject_id  (subject_type,subject_id)
#
FactoryBot.define do
  factory :account do
    name { Faker::Lorem.word }
    currency { :rub }
    code { :pending }
    kind { :active }
    trait :for_account_group do
      association :subject, factory: :account_group
    end
    trait :for_user do
      association :subject, factory: :user
    end
  end
end
