# == Schema Information
#
# Table name: exchange_rates
#
#  id         :bigint           not null, primary key
#  currency   :integer          not null
#  date       :date             not null
#  value      :decimal(, )      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :exchange_rate do
    currency { 1 }
    value { "9.99" }
    date { "2020-11-14" }
  end
end
