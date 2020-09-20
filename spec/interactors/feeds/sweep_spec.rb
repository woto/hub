# frozen_string_literal: true

require 'rails_helper'

describe Feeds::Sweep do
  let(:pid1) { 100 }
  let(:pid2) { pid1 + 100 }
  let(:pid3) { pid2 + 100 }
  let(:operation) { 'factory_bot' }
  let!(:feed1) { create(:feed, locked_by_pid: pid1, operation: operation) }
  let!(:feed2) { create(:feed, locked_by_pid: pid2, operation: operation) }
  let!(:feed3) { create(:feed, locked_by_pid: 0, operation: operation) }

  it 'sweeps stucked jobs' do
    expect(Process).to receive(:getpgid).with(pid1).and_return(pid1)
    expect(Process).to receive(:getpgid).with(pid2).and_raise(Errno::ESRCH)
    expect(Process).not_to receive(:getpgid).with(pid3)

    described_class.call

    expect(feed1.reload).to have_attributes(operation: operation, locked_by_pid: pid1)
    expect(feed2.reload).to have_attributes(operation: 'sweep', locked_by_pid: 0)
    expect(feed3.reload).to have_attributes(operation: operation, locked_by_pid: 0)
  end
end
