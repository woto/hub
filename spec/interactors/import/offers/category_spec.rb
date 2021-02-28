# frozen_string_literal: true

require 'rails_helper'

describe Import::Offers::Category do
  subject { described_class.call(offer, feed, categories) }

  RSpec.shared_examples 'hash categories error values' do |_parameter|
    it 'sets hash values correctly' do
      subject
      expect(offer).to eq(
        'feed_category_id' => -1,
        'feed_category_id_0' => -1,
        'feed_category_ids' => [-1]
      )
    end
  end

  let(:feed) { create(:feed, :with_attempt_uuid) }
  let(:categories) { feed.feed_categories_for_import }

  context 'when offer does not include categoryId' do
    let(:offer) { {} }

    it_behaves_like 'hash categories error values'

    it 'sends error metrics and logs' do
      expect(Rails).to receive_message_chain('logger.warn').with(
        { feed_id: feed.id, message: 'There is no categoryId key', object: nil }
      )
      expect(Yabeda).to receive_message_chain('hub.categories_errors.increment')
        .with({ feed_id: feed.id, message: 'There is no categoryId key' }, { by: 1 })
      subject
    end
  end

  context 'when offer has multiple categoryId' do
    let(:offer) do
      { 'categoryId' => [
        { Import::Offers::Hashify::HASH_BANG_KEY => 1 },
        { Import::Offers::Hashify::HASH_BANG_KEY => 'a' }
      ] }
    end

    it_behaves_like 'hash categories error values'

    it 'sends error metrics and logs' do
      expect(Rails).to receive_message_chain('logger.warn').with(
        { feed_id: feed.id, message: 'There are more than one values for categoryId key',
          object: { categoryId: [{ '#' => 1 }, { '#' => 'a' }] } }
      )
      expect(Yabeda).to receive_message_chain('hub.categories_errors.increment')
        .with({ feed_id: feed.id, message: 'There are more than one values for categoryId key' }, { by: 1 })
      subject
    end
  end

  context 'when offer includes categoryId' do
    let(:offer) { { 'categoryId' => [{ Import::Offers::Hashify::HASH_BANG_KEY => ext_id }] } }
    let(:ext_id) { Faker::Lorem.word }

    context 'when there are no corresponding value in categories' do
      it 'sends error metrics and logs' do
        expect(Rails).to receive_message_chain('logger.warn').with(
          { feed_id: feed.id, message: 'FeedCategory was not found',
            object: { categoryId: ext_id } }
        )
        expect(Yabeda).to receive_message_chain('hub.categories_errors.increment')
          .with({ feed_id: feed.id, message: 'FeedCategory was not found' }, { by: 1 })
        subject
        expect { subject }.not_to raise_error
      end

      it_behaves_like 'hash categories error values'
    end

    context 'when there are corresponding leaf category' do
      let!(:root_category) { create(:feed_category, feed: feed) }
      let!(:leaf_category) { create(:feed_category, feed: feed, parent: root_category, ext_id: ext_id) }

      it 'sets hash values correctly' do
        subject
        expect(offer).to eq(
          'feed_category_id' => leaf_category.id,
          'feed_category_id_0' => root_category.id,
          'feed_category_id_1' => leaf_category.id,
          'feed_category_ids' => [root_category.id, leaf_category.id]
        )
      end
    end

    context 'when there are corresponding non leaf category (which includes subdirectories)' do
      let!(:root_category) { create(:feed_category, feed: feed) }
      let!(:non_leaf_category) { create(:feed_category, feed: feed, parent: root_category, ext_id: ext_id) }
      let!(:leaf_category) { create(:feed_category, feed: feed, parent: non_leaf_category) }

      it 'creates surrogate category and sets hash values correctly' do
        subject
        expect(offer).to eq(
          'feed_category_id' => FeedCategory.last.id,
          'feed_category_id_0' => root_category.id,
          'feed_category_id_1' => non_leaf_category.id,
          'feed_category_id_2' => FeedCategory.last.id,
          'feed_category_ids' => [root_category.id, non_leaf_category.id, FeedCategory.last.id]
        )
        expect(FeedCategory.last).to have_attributes(
          feed_id: feed.id,
          ext_id: "#{non_leaf_category.ext_id}#{Import::Offers::Category::SURROGATE_KEY}",
          ext_parent_id: non_leaf_category.ext_id.to_s,
          attempt_uuid: feed.attempt_uuid,
          parent_not_found: false,
          name: Import::Offers::Category::SURROGATE_NAME,
          ancestry: "#{root_category.id}/#{non_leaf_category.id}",
          ancestry_depth: 2
        )
      end
    end
  end
end
