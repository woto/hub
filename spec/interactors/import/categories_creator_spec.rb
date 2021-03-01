# frozen_string_literal: true

require 'rails_helper'

describe Import::CategoriesCreator do
  subject do
    described_class.new(OpenStruct.new(feed: feed))
  end

  let(:doc) { Nokogiri::XML(xml).children.first }
  let(:feed) { create(:feed, :with_attempt_uuid) }

  let(:xml) do
    %(
      <category id="abc" parentId="def">Мелкая техника для кухни</category>
    )
  end

  describe '#append' do

    it 'increases total_count' do
      subject.append(doc)
      expect(subject.total_count).to eq(1)
    end

    context 'when processed category does not exist yet' do
      it 'creates child category' do
        expect { subject.append(doc) }.to change(FeedCategory, :count)

        feed_category = FeedCategory.last
        expect(feed_category).to have_attributes(
          feed_id: feed.id,
          ext_id: 'abc',
          name: 'Мелкая техника для кухни',
          ext_parent_id: 'def'
        )
      end
    end

    context 'when processed category already exists and its attributes differ' do
      let!(:feed_category) { create(:feed_category, feed: feed, ext_id: 'abc') }

      it 'updates its name' do
        lambda = -> { expect { subject.append(doc) }.not_to change(FeedCategory, :count) }
        expect(lambda).to(change { feed_category.reload.name })
      end

      it 'updates its ext_parent_id' do
        lambda = -> { expect { subject.append(doc) }.not_to change(FeedCategory, :count) }
        expect(lambda).to(change { feed_category.reload.ext_parent_id })
      end
    end

    context 'when processed category is the same as in the database' do
      before do
        create(:feed_category, feed: feed, ext_id: 'abc', ext_parent_id: 'def', name: 'Мелкая техника для кухни')
      end

      it 'does not issue update SQL' do
        lambda1 = -> { expect { subject.append(doc) }.not_to exceed_query_limit(1) }
        lambda2 = -> { expect(lambda1).not_to exceed_query_limit(1).with(/^SELECT/) }
        lambda2.call
      end
    end
  end

  describe '#flush' do
    before do
      subject.append(doc)
    end

    it "updates categories' attempt_uuid" do
      expect(subject.flush).to eq(1)
      expect(feed.attempt_uuid).to be_a(String)
      expect(FeedCategory.pluck('attempt_uuid')).to eq([feed.attempt_uuid])
    end
  end
end
