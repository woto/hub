# frozen_string_literal: true

require 'rails_helper'

describe Import::Categories::BindParents do
  subject { described_class.call(feed: feed) }

  let(:feed) { create(:feed) }
  let(:ext_id) { Faker::Alphanumeric.alphanumeric }

  context 'when processed category is changed' do
    let!(:parent) { create(:feed_category, feed: feed, ext_id: ext_id) }
    let!(:child) { create(:feed_category, feed: feed, ext_parent_id: ext_id) }

    it 'is not exceed 1 sql update' do
      expect { subject }.not_to exceed_query_limit(1).with(/^UPDATE/)
    end

    it 'is exceed 0 sql update' do
      expect { subject }.to exceed_query_limit(0).with(/^UPDATE/)
    end
  end

  context 'when processed category is not changed' do
    let!(:parent) { create(:feed_category, feed: feed, ext_id: ext_id) }
    let!(:child) { create(:feed_category, feed: feed, ext_parent_id: ext_id, parent: parent) }

    it 'is not exceed 0 sql updates' do
      expect { subject }.not_to exceed_query_limit(0).with(/^UPDATE/)
    end
  end

  describe 'standard simple flow' do
    let!(:parent) { create(:feed_category, feed: feed, ext_id: ext_id) }
    let!(:child) { create(:feed_category, feed: feed, ext_parent_id: ext_id) }

    it "updates child's parent" do
      subject
      expect(child.reload.parent).to eq(parent)
    end
  end

  context 'when there are several children and some of them has errors' do
    let!(:parent) { create(:feed_category, feed: feed, ext_id: ext_id) }
    let!(:invalid_child1) { create(:feed_category, feed: feed, ext_parent_id: SecureRandom.uuid) }
    let!(:child1) { create(:feed_category, feed: feed, ext_parent_id: ext_id) }
    let!(:invalid_child2) { create(:feed_category, feed: feed, ext_parent_id: SecureRandom.uuid) }
    let!(:child2) { create(:feed_category, feed: feed, ext_parent_id: ext_id) }

    it 'updates children in a error safe loop' do
      subject
      expect(child1.reload.parent).to eq(parent)
      expect(child2.reload.parent).to eq(parent)
    end
  end

  shared_context 'mock children_categories' do
    before do
      dbl = double
      allow(dbl).to receive(:find_each).and_yield(child)
      expect_any_instance_of(described_class).to receive(:children_categories).and_return(dbl)
    end
  end

  context 'when `parent` is a `child` of a child' do
    include_context 'mock children_categories'
    let!(:parent) { create(:feed_category, feed: feed, ext_id: child.ext_parent_id, parent: child) }
    let!(:child) { create(:feed_category, feed: feed, ext_parent_id: ext_id) }

    it 'does not update child and send metrics' do
      expect(Yabeda).to receive_message_chain('hub.bind_parents_error.increment')
        .with({ feed_id: feed.id, message: 'Unable to update child category' }, { by: 1 })
      subject
      expect(child).to be_invalid
      expect(child.errors.to_h).to eq({ base: 'Feedcategory cannot be a descendant of itself.' })
    end
  end

  context 'when `parent` of the `child` is not found' do
    include_context 'mock children_categories'
    let!(:child) { create(:feed_category, feed: feed, ext_parent_id: ext_id) }

    it 'does not update child and send metrics' do
      expect(Yabeda).to receive_message_chain('hub.bind_parents_error.increment')
        .with({ feed_id: feed.id, message: 'Parent category was not found' }, { by: 1 })
      expect(child).not_to receive(:update)
      subject
    end
  end
end
