# == Schema Information
#
# Table name: account_groups
#
#  id         :bigint           not null, primary key
#  identifier :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :account_group do
    sequence(:identifier) { |n| "identifier #{n}" }
  end
end
