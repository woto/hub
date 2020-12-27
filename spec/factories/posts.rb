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
    realm
    title { Faker::GreekPhilosophers.quote }
    status { 'draft' }
    user
    intro { Faker::Lorem.paragraph_by_chars(number: rand(100..1000)) }
    body { Faker::Lorem.paragraph_by_chars(number: rand(100..10_000)) }
    post_category
    published_at { 1.minute.ago }
    tags { [ 'tag' ] }
    currency { :usd }

    after(:build) do |post|
      date = (post.created_at || Time.current).to_date
      ExchangeRate.find_or_create_by!(currency: post.currency, date: date) do |rate|
        rate.value = rand(100)
      end
    end
  end
end
