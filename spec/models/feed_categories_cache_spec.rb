# frozen_string_literal: true

require 'rails_helper'

describe FeedCategoriesCache do
  let(:subject) { described_class.new(feed) }
  let(:feed) { create(:feed) }

  context 'when feed already has feed_categories' do
    let!(:feed_category) { create(:feed_category, feed: feed) }

    it 'fills items correctly' do
      expect(subject.items).to eq(
        feed_category.ext_id => described_class::Item.new(
          ext_id: feed_category.ext_id,
          id: feed_category.id,
          path_ids: feed_category.path_ids,
          attempt_uuid: feed_category.attempt_uuid
        )
      )
    end
  end

  describe '#find' do
    let(:item) do
      FeedCategoriesCache::Item.new(id: 'id', ext_id: 'ext_id', path_ids: [123], attempt_uuid: attempt_uuid)
    end
    let(:attempt_uuid) { SecureRandom.uuid }

    before do
      subject.append_or_update(**item.to_h)
    end

    context 'when same attempt_uuid' do
      it 'finds them' do
        expect(subject.find(ext_id: 'ext_id', attempt_uuid: attempt_uuid)).to eq(item)
      end
    end

    context 'when attempt_uuid not the same' do
      it 'does not find them' do
        expect(subject.find(ext_id: 'ext_id', attempt_uuid: SecureRandom)).to be_nil
      end
    end
  end

  describe '#append_or_update' do
    let(:feed_category) { build(:feed_category, feed: feed) }

    it 'appends items correctly' do
      expect(subject.items).to eq({})
      subject.append_or_update(id: 'id', ext_id: 'ext_id', path_ids: [123], attempt_uuid: 'attempt_uuid')
      expect(subject.items).to eq(
        'ext_id' => described_class::Item.new(
          ext_id: 'ext_id', id: 'id', path_ids: [123], attempt_uuid: 'attempt_uuid'
        )
      )
    end

    it 'updates items correctly' do
      subject.append_or_update(ext_id: 'ext_id', id: 'id1', path_ids: [123], attempt_uuid: 'attempt_uuid1')

      expect(subject.items).to eq(
        'ext_id' => described_class::Item.new(
          ext_id: 'ext_id', id: 'id1', path_ids: [123], attempt_uuid: 'attempt_uuid1'
        )
      )

      subject.append_or_update(ext_id: 'ext_id', id: 'id2', path_ids: [456], attempt_uuid: 'attempt_uuid2')

      expect(subject.items).to eq(
        'ext_id' => described_class::Item.new(
          ext_id: 'ext_id', id: 'id2', path_ids: [456], attempt_uuid: 'attempt_uuid2'
        )
      )
    end
  end

  describe '#==' do
    let(:feed) { create(:feed) }

    it 'equals to self' do
      create(:feed_category, feed: feed)
      feed_category_cache = described_class.new(feed)
      expect(feed_category_cache).to be == feed_category_cache
    end

    it 'equals to the same' do
      create(:feed_category, feed: feed)
      feed_category_cache1 = described_class.new(feed)
      feed_category_cache2 = described_class.new(feed)
      expect(feed_category_cache1).to be == feed_category_cache2
    end
  end

  describe 'nested categories' do
    let!(:root) { create(:feed_category, feed: feed) }
    let!(:cat1) { create(:feed_category, parent: root, feed: feed, attempt_uuid: SecureRandom.uuid) }
    let!(:cat2) { create(:feed_category, parent: root, feed: feed, attempt_uuid: SecureRandom.uuid) }
    let!(:cat3) { create(:feed_category, parent: cat1, feed: feed, attempt_uuid: SecureRandom.uuid) }

    it 'returns valid result' do
      expect(subject.items).to(
        match(
          root.ext_id => described_class::Item.new(
            id: root.id, path_ids: root.path_ids, ext_id: root.ext_id, attempt_uuid: root.attempt_uuid
          ),
          cat1.ext_id => described_class::Item.new(
            id: cat1.id, path_ids: cat1.path_ids, ext_id: cat1.ext_id, attempt_uuid: cat1.attempt_uuid
          ),
          cat2.ext_id => described_class::Item.new(
            id: cat2.id, path_ids: cat2.path_ids, ext_id: cat2.ext_id, attempt_uuid: cat2.attempt_uuid
          ),
          cat3.ext_id => described_class::Item.new(
            id: cat3.id, path_ids: cat3.path_ids, ext_id: cat3.ext_id, attempt_uuid: cat3.attempt_uuid
          )
        )
      )
    end
  end
end
