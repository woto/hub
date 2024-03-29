require 'rails_helper'

describe Elastic::CreateTokenizerIndexInteractor do
  subject { described_class.call }

  def exists?
    Elastic::CheckIndexExistsInteractor.call(index: Elastic::IndexName.pick('tokenizer')).object
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
      # TODO: add meta tag for skip creating index
      GlobalHelper.elastic_client.indices.delete index: Elastic::IndexName.pick('*').scoped

      expect(exists?).to eq(false)
      subject
      expect(exists?).to eq(true)
    end
  end
end
