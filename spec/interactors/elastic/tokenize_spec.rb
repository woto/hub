require 'rails_helper'

describe Elastic::Tokenize do
  subject { described_class.call(q: q) }

  context 'when query in russian' do
    let(:q) { 'Однажды в студёную зимнюю пору Я из лесу вышел' }
    it 'tokenizes query' do
      expect(subject).to have_attributes(object: ["однажды", "студёную", "зимнюю", "пору", "лесу", "вышел"])
    end
  end

  context 'when query in english' do
    let(:q) { 'The quick brown Fox jumps over the lazy dog' }
    it 'tokenizes query' do
      expect(subject).to have_attributes(object: ["quick", "brown", "fox", "jumps", "over", "lazy", "dog"])
    end
  end
end
