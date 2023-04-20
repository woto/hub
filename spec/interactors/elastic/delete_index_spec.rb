# frozen_string_literal: true

require 'rails_helper'

describe Elastic::DeleteIndex do
  subject { described_class.call(params) }

  def exists?(index)
    Elastic::CheckIndexExists.call(index: index, allow_no_indices: false).object
  end

  context 'when index_name param has particular name' do
    let(:params) { { index: index } }
    let(:index) { Elastic::IndexName.pick(rand.to_s) }

    it 'deletes index' do
      GlobalHelper.elastic_client.indices.create index: index.scoped
      expect(exists?(index)).to eq(true)
      subject
      expect(exists?(index)).to eq(false)
    end
  end

  describe 'when index_name is wildcard' do
    let(:params) { { index: Elastic::IndexName.pick('*') } }

    context 'when any index exist' do
      it 'deletes all indexes' do
        expect(exists?(Elastic::IndexName.pick('*'))).to eq(true)
        subject
        expect(exists?(Elastic::IndexName.pick('*'))).to eq(false)
      end
    end

    context 'when there no any index' do
      it 'does not fail during remove' do
        subject
        expect(exists?(Elastic::IndexName.pick('*'))).to eq(false)
        subject
      end
    end
  end

  describe '#ignore_unavailable and index is absent' do
    let(:index) { Elastic::IndexName.pick(rand.to_s) }

    context 'when ignore_unavailable param is false' do
      let(:params) { { index: index, ignore_unavailable: false } }

      it 'raises error because of absence of index' do
        expect { subject }.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
      end
    end

    context 'when ignore_unavailable param is true' do
      let(:params) { { index: index, ignore_unavailable: true } }

      it 'does not raise error even though absence of index' do
        expect { subject }.not_to raise_error
      end
    end
  end
end
