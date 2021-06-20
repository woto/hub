# frozen_string_literal: true

require 'rails_helper'

describe GroupsStore do
  subject { described_class.new }

  let(:advertiser1) { create(:advertiser, id: 123) }
  let(:advertiser2) { create(:advertiser, id: 234) }
  let(:feed) { create(:feed, id: 345) }

  before do
    subject.append(advertiser1.id, :advertiser_id)
    subject.append(advertiser2.id, :advertiser_id)
    subject.append(feed.id, :feed_id)
  end

  context 'when there are 2 groups of models (Advertiser and Feed) with 3 elements' do
    it 'makes 2 separate requests (not three)' do
      expect do
        subject.find(advertiser1.id, :advertiser_id)
      end.not_to exceed_query_limit(2).with(/^SELECT/)
    end
  end

  # NOTE: there is no particular reason to raise error
  context 'when needle is not found' do
    it 'raises error' do
      expect { subject.find(Faker::Alphanumeric.alphanumeric, :advertiser_id) }.to(
        raise_error('needle is not found')
      )
    end
  end

  it 'caches results on subsequent requests' do
    subject.find(feed.id, :feed_id)

    expect do
      subject.find(advertiser1.id, :advertiser_id)
    end.not_to exceed_query_limit(0)
  end
end
