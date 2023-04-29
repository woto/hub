# frozen_string_literal: true

# == Schema Information
#
# Table name: mentions
#
#  id            :bigint           not null, primary key
#  canonical_url :text
#  html          :text
#  kinds         :jsonb            not null
#  published_at  :datetime
#  sentiments    :jsonb
#  title         :string
#  url           :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  hostname_id   :bigint
#  user_id       :bigint           not null
#
# Indexes
#
#  index_mentions_on_hostname_id  (hostname_id)
#  index_mentions_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (hostname_id => hostnames.id)
#  fk_rails_...  (user_id => users.id)
#

require_relative '../support/shrine_image'

FactoryBot.define do
  factory :mention do
    user
    entities { [association(:entity)] }
    url { Faker::Internet.url }

    transient do
      index { true }
    end

    after(:create) do |mention, evaluator|
      mention.__elasticsearch__.index_document if evaluator.index
    end
  end
end
