# frozen_string_literal: true

require 'rails_helper'

describe Import::LockFeed do
  subject { described_class.call(params) }

  context 'with feed argument' do
    let(:params) { { feed: feed } }
    let(:feed) { create(:feed) }

    it 'calls FetchFeedQuery.call(feed: feed)' do
      expect(FetchFeedQuery).to receive(:call!).with(feed: feed).and_call_original
      subject
    end
  end

  context 'without feed argument' do
    let(:params) { { feed: nil } }
    let(:feed) { create(:feed) }

    it 'calls FetchFeedQuery.call(feed: nil)' do
      expect(FetchFeedQuery).to receive(:call!).with(feed: nil).and_call_original
      subject
    end
  end

  describe 'simple success flow' do
    let(:params) { { feed: nil } }
    let(:feed) do
      create(:feed,
             operation: 'manual',
             locked_by_pid: 0,
             attempt_uuid: SecureRandom.uuid,
             processing_started_at: 2.hours.ago,
             error_class: Faker::Lorem.word,
             error_text: Faker::Lorem.word,
             priority: Faker::Number.number(digits: 5))
    end

    it 'updates feed attributes correctly and outputs logs' do
      allow(Rails).to receive_message_chain('logger.info')
      expect(Rails).to receive_message_chain('logger.info').with({ feed_id: feed.id, message: 'Selected feed' })
      expect(Rails).to receive_message_chain('logger.info').with({ feed_id: feed.id, message: 'Locked feed' })

      freeze_time do
        expect(subject.object).to have_attributes(
          operation: 'lock feed',
          locked_by_pid: match(a_value > 0),
          attempt_uuid: match(/\b[0-9a-f]{8}\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\b[0-9a-f]{12}\b/),
          processing_started_at: Time.current,
          error_class: nil,
          error_text: nil,
          priority: 0
        )
      end
      expect(subject).to be_a_success
    end
  end

  context 'when there are no available feeds' do
    let(:params) { { feed: nil } }
    let(:feed) { create(:feed, locked_by_pid: Faker::Number.number(digits: 5)) }

    it 'does not lock anyone' do
      allow(Rails).to receive_message_chain('logger.info')
      expect(Rails).to receive_message_chain('logger.info').with({ message: 'No suitable feeds were found' })
      expect(subject).to be_a_failure
    end
  end

  context 'when feed is inactive' do
    let(:params) { { feed: nil } }
    let!(:feed) { create(:feed, locked_by_pid: 0, is_active: false) }

    it 'does not lock feed' do
      expect(subject.object.locked_by_pid).to eq(0)
      expect(subject).to be_a_failure
    end

    it 'logs about that' do
      allow(Rails).to receive_message_chain('logger.info')
      expect(Rails).to receive_message_chain('logger.info').with(message: 'Feed is inactive',
                                                                 feed_id: feed.id)
      expect(subject).to be_a_failure
    end
  end

  context 'when advertiser is inactive' do
    let(:params) { { feed: nil } }
    let(:advertiser) { create(:advertiser, is_active: false) }

    before do
      create(:feed, advertiser: advertiser, locked_by_pid: 0)
    end

    it 'does not lock feed' do
      expect(subject.object.locked_by_pid).to eq(0)
      expect(subject).to be_a_failure
    end

    it 'logs about that' do
      allow(Rails).to receive_message_chain('logger.info')
      expect(Rails).to receive_message_chain('logger.info').with(message: 'Advertiser is inactive',
                                                                 advertiser_id: advertiser.id)
      expect(subject).to be_a_failure
    end
  end
end
