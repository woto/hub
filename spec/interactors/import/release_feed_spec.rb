# frozen_string_literal: true

require 'rails_helper'

describe Import::ReleaseFeedInteractor do
  subject { described_class.call(param) }

  let(:feed) do
    create(:feed,
           operation: 'manual',
           locked_by_tid: Faker::Lorem.word,
           processing_finished_at: 1.hour.ago,
           error_class: Faker::Lorem.word,
           error_text: Faker::Lorem.word)
  end

  context 'when there is no error was happened and context.error is nil' do
    let(:param) { { feed: feed } }

    it 'updates feed with new attributes values with nil errors' do
      freeze_time do
        subject
        expect(feed).to have_attributes(operation: 'release feed',
                                        locked_by_tid: '',
                                        processing_finished_at: Time.current,
                                        error_class: nil,
                                        error_text: nil)
      end
    end
  end

  context 'when error was happened and context.error is not nil' do
    let(:param) { { feed: feed, error: StandardError.new('for test purposes') } }

    it 'updates feed with new attributes values with nil errors' do
      freeze_time do
        subject
        expect(feed).to have_attributes(operation: 'release feed',
                                        locked_by_tid: '',
                                        processing_finished_at: Time.current,
                                        error_class: 'StandardError',
                                        error_text: /for test purposes/)
      end
    end
  end
end
