# frozen_string_literal: true

require 'rails_helper'

describe FetchFeedQuery do
  subject { described_class.call(feed: nil) }

  context 'when feed passed' do
    subject { described_class.call(feed: feed) }

    let(:feed) { create(:feed) }

    it 'adds where feed condition' do
      expect(subject.object.to_sql).to match(/"feeds"."id" = #{feed.id}/)
    end
  end

  it 'fetches according to sorting order' do
    expect(subject.object.to_sql).to match('priority DESC, processing_finished_at ASC NULLS FIRST')
  end

  it 'adds locking statement' do
    expect(subject.object.to_sql).to match('FOR UPDATE NOWAIT')
  end
end
