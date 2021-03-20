# frozen_string_literal: true

# == Schema Information
#
# Table name: feed_categories
#
#  id             :bigint           not null, primary key
#  ancestry       :string
#  ancestry_depth :integer          default(0)
#  attempt_uuid   :uuid
#  name           :string
#  raw            :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  ext_id         :string           not null
#  ext_parent_id  :string
#  feed_id        :bigint           not null
#
# Indexes
#
#  index_feed_categories_on_ancestry            (ancestry)
#  index_feed_categories_on_feed_id             (feed_id)
#  index_feed_categories_on_feed_id_and_ext_id  (feed_id,ext_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (feed_id => feeds.id)
#
require 'rails_helper'

describe FeedCategory, type: :model do
  let!(:subject) { create(:feed_category, name: 'Child category', parent: root, feed: feed) }
  let(:root) { create(:feed_category, name: 'Root category', feed: feed) }
  let(:feed) { create(:feed, name: 'Feed', advertiser: advertiser) }
  let(:advertiser) { create(:advertiser, name: 'Advertiser') }

  it_behaves_like 'elasticable'

  describe '#as_indexed_json' do
    specify do
      expect(subject.as_indexed_json).to include(
        id: subject.id,
        name: subject.name,
        ancestry_depth: subject.ancestry_depth,
        path: subject.path.map(&:name)[0...-1],
        leaf: subject.children.none?,
        ext_id: subject.ext_id,
        ext_parent_id: subject.ext_parent_id,
        feed_id: subject.feed_id
      )
    end
  end

  describe '#to_label' do
    context 'when name is not nil' do
      specify do
        expect(subject.to_label).to eq(subject.name)
      end
    end

    context 'when name is nil' do
      let!(:subject) { create(:feed_category, name: nil) }

      specify do
        I18n.with_locale(:ru) do
          expect(subject.to_label).to eq('Без названия')
        end
      end
    end
  end

  describe '#to_long_label' do
    specify do
      expect(subject.to_long_label).to eq('Advertiser -> Feed -> Root category -> Child category')
    end
  end
end
