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
require 'rails_helper'

RSpec.describe Feed, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
