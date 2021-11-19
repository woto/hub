# == Schema Information
#
# Table name: exchange_rates
#
#  id            :bigint           not null, primary key
#  currencies    :jsonb            not null
#  date          :date             not null
#  extra_options :jsonb            not null
#  posts_count   :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :exchange_rate do
    date { Date.current }
  end
end
