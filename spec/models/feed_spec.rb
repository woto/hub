# frozen_string_literal: true

# == Schema Information
#
# Table name: feeds
#
#  id                     :bigint           not null, primary key
#  advertiser_updated_at  :datetime
#  attempt_uuid           :uuid
#  categories_count       :integer
#  downloaded_file_size   :bigint
#  downloaded_file_type   :string
#  error_class            :string
#  error_text             :text
#  is_active              :boolean          default(TRUE), not null
#  language               :string
#  locked_by_pid          :integer          default(0), not null
#  name                   :string           not null
#  network_updated_at     :datetime
#  offers_count           :integer
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
require 'rails_helper'

describe Feed, type: :model do
  it_behaves_like 'elasticable'
  describe '#active' do
    let!(:advertiser1) { create(:advertiser, is_active: true) }
    let!(:feed1) { create(:feed, is_active: true, advertiser: advertiser1) }

    before do
      advertiser2 = create(:advertiser, is_active: false)
      create(:feed, is_active: true, advertiser: advertiser2)
      create(:feed, is_active: false, advertiser: advertiser2)
      create(:feed, is_active: false, advertiser: advertiser1)
    end

    it 'returns only active feeds of active advertisers' do
      expect(described_class.active).to eq([feed1])
    end
  end
end
