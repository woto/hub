require 'rails_helper'

describe Elastic::CreateTokenizerIndex do
  subject { described_class.call }

  def exists?
    Elastic::CheckIndexExists.call(index_name: Elastic::IndexName.tokenizer).object
  end

  context 'when index already exists' do
    it 'creates index anyway' do
      subject
      expect(exists?).to eq(true)
      subject
      expect(exists?).to eq(true)
    end
  end

  context 'when index does not exist' do
    it 'creates index' do
      expect(exists?).to eq(false)
      subject
      expect(exists?).to eq(true)
    end
  end
end
