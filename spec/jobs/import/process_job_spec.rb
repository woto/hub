# frozen_string_literal: true

require 'rails_helper'

describe Import::ProcessJob, type: :job do
  subject { described_class.perform_now }

  specify do
    expect(Import::ProcessInteractor).to receive(:call)
    subject
  end
end
