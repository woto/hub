# frozen_string_literal: true

# == Schema Information
#
# Table name: mentions
#
#  id               :bigint           not null, primary key
#  amount           :decimal(, )      not null
#  currency         :integer          not null
#  entities_count   :integer          default(0), not null
#  kind             :integer          not null
#  published_at     :datetime
#  sentiment        :integer          not null
#  status           :integer          not null
#  tags             :jsonb
#  url              :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  exchange_rate_id :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_mentions_on_exchange_rate_id  (exchange_rate_id)
#  index_mentions_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (exchange_rate_id => exchange_rates.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :mention do
    user
    currency { %i[rub usd eur].sample }
    amount { rand(1..10) }
    entities { [association(:entity)] }
    status { %i[draft_mention pending_mention].sample }
    url { Faker::Internet.url }
    tags { Faker::Lorem.sentences(number: rand(2..10)) }
    sentiment { Mention.sentiments.keys.sample }
    kind { Mention.kinds.keys.sample }
  end
end
