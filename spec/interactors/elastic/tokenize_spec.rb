# frozen_string_literal: true

require 'rails_helper'

describe Elastic::Tokenize do
  before do
    # TODO: think about refactoring. Code creating index should be moved to spec/support?
    Elastic::CreateTokenizerIndex.call
  end

  context 'when q param is missed' do
    subject { described_class.call }

    it 'raises error' do
      expect { subject }.to raise_error
    end
  end

  context 'when query in russian' do
    subject { described_class.call(q: 'Однажды в студёную зимнюю пору Я из лесу вышел') }

    it 'tokenizes query' do
      expect(subject).to have_attributes(object: %w[однажды студёную зимнюю пору лесу вышел])
    end
  end

  context 'when query in english' do
    subject { described_class.call(q: 'The quick brown Fox jumps over the lazy dog') }

    it 'tokenizes query' do
      expect(subject).to have_attributes(object: %w[quick brown fox jumps over lazy dog])
    end
  end
end
