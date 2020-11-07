# == Schema Information
#
# Table name: accounts
#
#  id           :bigint           not null, primary key
#  amount       :integer          default(0), not null
#  code         :integer          not null
#  currency     :integer          not null
#  kind         :integer          not null
#  name         :string           not null
#  subject_type :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  subject_id   :bigint           not null
#
# Indexes
#
#  index_accounts_on_subject_type_and_subject_id  (subject_type,subject_id)
#
FactoryBot.define do
  factory :account do
    name { "MyString" }
    type { 1 }
    amount { 1 }
    subject { nil }
    currency { 1 }
  end
end
