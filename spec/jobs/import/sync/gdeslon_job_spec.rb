# frozen_string_literal: true

require 'rails_helper'

describe Sync::GdeslonJob, type: :job do
  subject { described_class.perform_now }

  it 'receives interactor call' do
    expect(Sync::Gdeslon::SyncInteractor).to receive(:call)
    subject
  end
end
