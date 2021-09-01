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
#  language               :string
#  locked_by_pid          :integer          default(0), not null
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
require 'rails_helper'

describe Feed, type: :model do
  it_behaves_like 'logidzable'
  it_behaves_like 'elasticable'

  describe '#as_indexed_json' do
    subject { create(:feed) }

    it 'returns expected structure' do
      expect(subject.as_indexed_json).to include(
        'id' => subject.id,
        'raw' => subject.raw,
        'advertiser_id' => subject.advertiser.id,
        'advertiser_raw' => subject.advertiser.raw
      )
    end
  end

  describe '#active' do
    subject! { create(:feed, is_active: true, advertiser: advertiser1) }

    let(:advertiser1) { create(:advertiser, is_active: true) }

    before do
      advertiser2 = create(:advertiser, is_active: false)
      create(:feed, is_active: true, advertiser: advertiser2)
      create(:feed, is_active: false, advertiser: advertiser2)
      create(:feed, is_active: false, advertiser: advertiser1)
    end

    it 'returns only active feeds of active advertisers' do
      expect(described_class.active).to eq([subject])
    end
  end

  context 'when factory with transient with_downloaded_file' do
    subject! { create(:feed, with_downloaded_file: file_fixture('feeds/corrupted_archive.zip')) }

    it 'copies file to expected place' do
      subject
      expect(Pathname.new(subject.file.path)).to be_file
    end
  end

  describe '#slug' do
    subject { create(:feed, name: 'Фид') }

    specify do
      expect(subject.slug).to eq("#{subject.id}-fid")
    end
  end

  describe '#slug_with_advertiser' do
    subject { create(:feed, name: 'Feed', advertiser: advertiser) }

    let(:advertiser) { create(:advertiser, name: 'Advertiser') }

    specify do
      expect(subject.slug_with_advertiser).to eq("#{advertiser.id}-advertiser+#{subject.id}-feed")
    end
  end

  describe '#to_label' do
    subject { create(:feed, name: 'Feed') }

    specify do
      expect(subject.to_label).to eq('Feed')
    end
  end

  describe '#to_long_label' do
    subject { create(:feed, name: 'Feed', advertiser: advertiser) }

    let(:advertiser) { create(:advertiser, name: 'Advertiser') }

    specify do
      expect(subject.to_long_label).to eq('Advertiser -> Feed')
    end
  end
end
