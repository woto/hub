# frozen_string_literal: true

require 'rails_helper'

describe Import::CategoriesCreator do
  subject do
    described_class.new(OpenStruct.new(feed: feed))
  end

  let(:doc) { Nokogiri::XML(xml).children.first }
  let(:feed) { create(:feed) }

  let(:xml) do
    %(
      <category id="abc" parentId="def">тест</category>
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
          name: 'тест',
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
        create(:feed_category, feed: feed, ext_id: 'abc', ext_parent_id: 'def', name: 'тест',
                               raw: '<category id="abc" parentId="def">&#x442;&#x435;&#x441;&#x442;</category>')
      end

      it 'does not issue update SQL' do
        expect { subject.append(doc) }.not_to exceed_query_limit(0).with(/^UPDATE/)

        # lambda1 = -> { expect { subject.append(doc) }.not_to exceed_query_limit(1) }
        # lambda2 = -> { expect(lambda1).not_to exceed_query_limit(1).with(/^SELECT/) }
        # lambda1.call
      end
    end
  end

  describe '#flush' do
    let(:obsolete_attempt_uuid) { SecureRandom.uuid }

    before do
      subject.append(doc)
      create(:feed_category, feed: feed, attempt_uuid: obsolete_attempt_uuid)
    end

    it "updates only those categories' attempt_uuid which were seen before flush (during #append invocations)" do
      expect(feed.feed_categories.count).to eq(2)
      expect(subject.flush).to eq(1)
      expect(feed.attempt_uuid).to be_a(String)
      expect(FeedCategory.pluck('attempt_uuid')).to contain_exactly(feed.attempt_uuid, obsolete_attempt_uuid)
    end
  end
end
