# frozen_string_literal: true

# == Schema Information
#
# Table name: feeds
#
#  id                     :bigint           not null, primary key
#  advertiser_updated_at  :datetime
#  attempt_uuid           :uuid
#  categories_count       :integer
#  data                   :jsonb
#  downloaded_file_size   :bigint
#  downloaded_file_type   :string
#  error_class            :string
#  error_text             :text
#  index_name             :string
#  is_active              :boolean          default(TRUE)
#  language               :string
#  locked_by_pid          :integer          default(0), not null
#  name                   :string           not null
#  network_updated_at     :datetime
#  offers_count           :integer
#  operation              :string           not null
#  priority               :integer          default(0), not null
#  processing_finished_at :datetime
#  processing_started_at  :datetime
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
require 'rspec/rails/file_fixture_support.rb'

FactoryBot.define do

  factory :feed do
    operation { 'factory_bot' }
    name { Faker::App.name }
    synced_at { 3.days.ago }
    advertiser
    ext_id { Faker::Alphanumeric.alphanumeric }
    url { Faker::Internet.url }

    trait :with_attempt_uuid do
      attempt_uuid { SecureRandom.uuid }
    end
  end
end