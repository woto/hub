# frozen_string_literal: true

require 'rails_helper'

describe Import::SweepJob, type: :job do
  subject { described_class.perform_now }

  specify do
    expect(Import::Sweep).to receive(:call)
    subject
  end
end
