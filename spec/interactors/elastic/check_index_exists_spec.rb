# frozen_string_literal: true

require 'rails_helper'

describe Elastic::CheckIndexExists do

  context 'when input params does not include index_name' do
    subject { described_class.call }

    it { expect { subject }.to raise_error }
  end

  context 'when index does not exist' do
    subject { described_class.call(index_name: rand.to_s) }

    it { is_expected.to have_attributes(object: false) }
    it { is_expected.to be_failure }
  end

  context 'when index exists' do
    subject { described_class.call(index_name: Elastic::IndexName.wildcard) }

    it { is_expected.to have_attributes(object: true) }
    it { is_expected.to be_success }
  end
end
