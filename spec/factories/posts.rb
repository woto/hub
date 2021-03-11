# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id               :bigint           not null, primary key
#  comment          :text
#  currency         :integer          not null
#  extra_options    :jsonb
#  price            :decimal(, )      default(0.0), not null
#  priority         :integer          default(0), not null
#  published_at     :datetime         not null
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
    title do
      # Faker::GreekPhilosophers.quote
      Faker::Lorem.sentence(word_count: 2, random_words_to_add: 12)
    end

    status { :draft }

    user

    intro do
      Faker::Lorem.paragraph_by_chars(number: rand(100..1000))
      # Faker::Lorem.paragraph(sentence_count: 10, random_sentences_to_add: 20)
    end

    body do
      Faker::Lorem.paragraph_by_chars(number: rand(100..10_000))
      # Faker::Lorem.paragraph(sentence_count: 10, random_sentences_to_add: 50)
    end

    published_at do
      Faker::Date.between(from: 5.months.ago, to: Time.current)
    end

    tags do
      Faker::Lorem
        .sentences(number: rand(1..10))
        .map { |tag| tag.tr('.', '').split(' ') }
        .map { |arr| arr.sample(rand(1..3)).join(' ') }
        .select(&:present?)
    end

    currency { :usd }

    created_at do
      Faker::Date.between(from: 2.years.ago, to: Time.current)
    end

    transient do
      realm_kind { :post }
      realm_locale { :ru }
    end

    realm do
      Realm.default_realm(kind: realm_kind, locale: realm_locale)
    end

    post_category do
      association :post_category,
                  realm: Realm.default_realm(kind: realm_kind, locale: realm_locale)
    end

    after(:build) do |post|
      date = (post.created_at || Time.current).to_date
      ExchangeRate.find_or_create_by!(currency: post.currency, date: date) do |rate|
        rate.value = rand(1..100)
      end
    end
  end
end
