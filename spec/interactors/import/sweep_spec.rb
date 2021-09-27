# frozen_string_literal: true

require 'rails_helper'

describe Import::Sweep do
  let(:identity1) { Faker::Lorem.word }
  let(:identity2) { Faker::Lorem.word }
  let(:tid1) { Faker::Lorem.word }
  let(:tid2) { Faker::Lorem.word }

  let!(:feed1) { create(:feed, locked_by_tid: GlobalHelper.tid_helper(identity1, tid1), operation: 'manual') }
  let!(:feed2) { create(:feed, locked_by_tid: GlobalHelper.tid_helper(identity2, tid2), operation: 'manual') }
  let!(:feed3) { create(:feed, locked_by_tid: '', operation: 'manual') }

  it 'sweeps stucked job for feed2 and do not touch feed3' do

    stubbed_workers = [[identity1, tid1, nil]]
    expect(Sidekiq::Workers).to receive(:new).and_return(stubbed_workers)

    described_class.call

    expect(feed1.reload).to have_attributes(operation: 'manual', locked_by_tid: GlobalHelper.tid_helper(identity1, tid1))
    expect(feed2.reload).to have_attributes(operation: 'sweep', locked_by_tid: '')
    expect(feed3.reload).to have_attributes(operation: 'manual', locked_by_tid: '')
  end
end
