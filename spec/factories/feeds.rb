# == Schema Information
#
# Table name: feeds
#
#  id                     :bigint           not null, primary key
#  advertiser_updated_at  :datetime
#  categories_count       :integer
#  data                   :jsonb
#  last_attempt_uuid      :uuid
#  last_error             :text
#  last_succeeded_at      :datetime
#  last_synced_at         :datetime         not null
#  locked_by_pid          :integer          default(0), not null
#  name                   :string
#  network_updated_at     :datetime
#  offers_count           :integer
#  processing_finished_at :datetime
#  processing_started_at  :datetime
#  url                    :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  advertiser_id          :bigint           not null
#  ext_id                 :string           not null
#
# Indexes
#
#  index_feeds_on_advertiser_id  (advertiser_id)
#
# Foreign Keys
#
#  fk_rails_...  (advertiser_id => advertisers.id)
#
FactoryBot.define do
  factory :feed do
    advertiser { nil }
    name { "MyString" }
    url { "MyString" }
    locked { 1 }
    last_error { "MyText" }
    last_attempt_uuid { "" }
    processing_started_at { "2020-07-15 21:30:37" }
    processing_finished_at { "2020-07-15 21:30:37" }
    data { "" }
  end
end
