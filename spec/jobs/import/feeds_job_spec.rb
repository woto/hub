# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Import::FeedsJob, type: :job do
  subject { described_class.perform_now }

  specify do
    expect(Import::Process).to receive(:call)
    subject
  end
end
