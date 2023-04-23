# frozen_string_literal: true

require 'rails_helper'

shared_examples 'surrogate category already exists' do
  it 'does not create new surrogate category' do
    expect do
      subject
    end.not_to change(FeedCategory, :count)
  end

  it 'updates surrogate category attempt_uuid' do
    expect { subject }.to change { surrogate_category.reload.attempt_uuid }
    expect(surrogate_category.reload).to have_attributes(attempt_uuid: feed.attempt_uuid)
  end

  it 'calls categories_cache#append_or_update and has correct last returned result' do
    expect(categories_cache).to receive(:append_or_update).and_call_original

    expect(subject).to match(
      FeedCategoriesCache::Item.new(
        id: surrogate_category.id,
        ext_id: surrogate_category.ext_id,
        path_ids: surrogate_category.path_ids,
        attempt_uuid: feed.attempt_uuid
      )
    )
  end

  it 'does not execute update with same attempt_uuid on a second seen surrogate category' do
    expect { described_class.call(feed, categories_cache, parent) }.to exceed_query_limit(0).with(/^UPDATE/)
    expect { described_class.call(feed, categories_cache, parent) }.not_to exceed_query_limit(0).with(/^INSERT/)
    expect { described_class.call(feed, categories_cache, parent) }.not_to exceed_query_limit(0).with(/^UPDATE/)
  end
end

shared_examples 'surrogate category does not exist yet' do
  it 'does not execute update with same attempt_uuid on a second seen surrogate category' do
    expect { described_class.call(feed, categories_cache, parent) }.to exceed_query_limit(0).with(/^INSERT/)
    expect { described_class.call(feed, categories_cache, parent) }.not_to exceed_query_limit(0).with(/^INSERT/)
    expect { described_class.call(feed, categories_cache, parent) }.not_to exceed_query_limit(0).with(/^UPDATE/)
  end

  it 'creates new surrogate category' do
    expect { subject }.to change(FeedCategory, :count)
  end

  it 'calls categories_cache#append_or_update and has correct last returned result' do
    expect(categories_cache).to receive(:append_or_update).and_call_original

    expect(subject).to match(
      FeedCategoriesCache::Item.new(
        id: FeedCategory.last.id,
        ext_id: FeedCategory.last.ext_id,
        path_ids: FeedCategory.last.path_ids,
        attempt_uuid: feed.attempt_uuid
      )
    )
  end
end

describe Import::Offers::SurrogateCategoryInteractor do
  let(:feed) { create(:feed) }
  let(:categories_cache) { FeedCategoriesCache.new(feed) }
  let(:offer) { create(:offer) }

  context 'with parent_category argument' do
    subject { described_class.call(feed, categories_cache, parent) }

    let(:parent) { create(:feed_category, feed: feed) }

    context 'when surrogate category already exists' do
      let!(:surrogate_category) do
        create(:feed_category, feed: feed, ext_id: "#{parent.ext_id}#{Import::Offers::CategoryInteractor::SURROGATE_KEY}",
                               ext_parent_id: parent.ext_id, parent: parent)
      end

      it_behaves_like 'surrogate category already exists'
    end

    context 'when surrogate category does not exist yet' do
      it 'creates surrogate category with valid params' do
        subject

        expect(FeedCategory.last).to have_attributes(
          ancestry: parent.id.to_s,
          ancestry_depth: 1,
          attempt_uuid: feed.attempt_uuid,
          name: nil,
          raw: nil,
          ext_id: "#{parent.ext_id}#{Import::Offers::CategoryInteractor::SURROGATE_KEY}",
          ext_parent_id: parent.ext_id,
          feed_id: feed.id
        )
      end

      it_behaves_like 'surrogate category does not exist yet'
    end
  end

  context 'without parent_category argument' do
    subject { described_class.call(feed, categories_cache) }

    let(:parent) { nil }

    context 'when surrogate category already exists' do
      let!(:surrogate_category) do
        create(:feed_category, feed: feed, ext_id: Import::Offers::CategoryInteractor::SURROGATE_KEY)
      end

      it_behaves_like 'surrogate category already exists'
    end

    context 'when surrogate category does not exist yet' do
      it 'creates surrogate category with valid params' do
        subject

        expect(FeedCategory.last).to have_attributes(
          ancestry: nil,
          ancestry_depth: 0,
          attempt_uuid: feed.attempt_uuid,
          name: nil,
          raw: nil,
          ext_id: Import::Offers::CategoryInteractor::SURROGATE_KEY,
          ext_parent_id: nil,
          feed_id: feed.id
        )
      end

      it_behaves_like 'surrogate category does not exist yet'
    end
  end
end
