# == Schema Information
#
# Table name: account_groups
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :account_group do
    name { "MyString" }
  end
end
