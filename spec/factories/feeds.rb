# frozen_string_literal: true

# == Schema Information
#
# Table name: feeds
#
#  id                     :bigint           not null, primary key
#  attempt_uuid           :uuid
#  categories_count       :integer          default(0), not null
#  downloaded_file_size   :bigint
#  downloaded_file_type   :string
#  error_class            :string
#  error_text             :text
#  feed_categories_count  :integer          default(0), not null
#  is_active              :boolean          default(TRUE), not null
#  languages              :jsonb
#  locked_by_tid          :string           default(""), not null
#  name                   :string           not null
#  offers_count           :integer          default(0), not null
#  operation              :string           not null
#  priority               :integer          default(0), not null
#  processing_finished_at :datetime
#  processing_started_at  :datetime
#  raw                    :text
#  succeeded_at           :datetime
#  synced_at              :datetime
#  url                    :string           not null
#  xml_file_path          :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  advertiser_id          :bigint           not null
#  ext_id                 :string
#
# Indexes
#
#  index_feeds_on_advertiser_id  (advertiser_id)
#
# Foreign Keys
#
#  fk_rails_...  (advertiser_id => advertisers.id)
#
require 'rspec/rails/file_fixture_support'

FactoryBot.define do
  factory :feed do
    operation { 'manual' }
    name { Faker::App.name }
    synced_at { 3.days.ago }
    advertiser
    ext_id { Faker::Alphanumeric.alphanumeric }
    url { Faker::Internet.url }
    attempt_uuid { SecureRandom.uuid }

    transient do
      with_downloaded_file { nil }
    end

    after(:create) do |feed, evaluator|
      FileUtils.cp evaluator.with_downloaded_file, feed.file.path if evaluator.with_downloaded_file
    end
  end
end
