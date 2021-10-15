# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id               :bigint           not null, primary key
#  amount           :decimal(, )      not null
#  currency         :integer          not null
#  description      :text
#  extra_options    :jsonb
#  priority         :integer          default(0), not null
#  published_at     :datetime
#  status           :integer          not null
#  tags             :jsonb
#  title            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  exchange_rate_id :bigint           not null
#  post_category_id :bigint           not null
#  realm_id         :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_posts_on_exchange_rate_id  (exchange_rate_id)
#  index_posts_on_post_category_id  (post_category_id)
#  index_posts_on_realm_id          (realm_id)
#  index_posts_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (exchange_rate_id => exchange_rates.id)
#  fk_rails_...  (post_category_id => post_categories.id)
#  fk_rails_...  (realm_id => realms.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :post do
    user
    title { Faker::Lorem.sentence(word_count: 2, random_words_to_add: 12) }
    status { %i[draft_post pending_post].sample }
    intro { Faker::Lorem.paragraph_by_chars(number: rand(100..1000)) }
    body { Faker::Lorem.paragraph_by_chars(number: rand(100..10_000)) }
    published_at { Faker::Date.between(from: 5.months.ago, to: Time.current) }
    tags { Faker::Lorem.sentences(number: rand(2..10)) }
    currency { %i[rub usd eur].sample }
    realm { post_category.realm }
    transient do
      realm_kind { Realm.kinds.keys.sample }
      realm_locale { I18n.available_locales.sample }
    end
    post_category do
      association :post_category, realm: Realm.pick(kind: realm_kind, locale: realm_locale)
    end
    description { Faker::Lorem.sentence }
  end
end
