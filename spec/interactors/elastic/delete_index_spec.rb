# frozen_string_literal: true

require 'rails_helper'

describe Elastic::DeleteIndex do
  subject { described_class.call(params) }

  def exists?(index_name)
    Elastic::CheckIndexExists.call(index_name: index_name, allow_no_indices: false).object
  end

  context 'when index_name param has particular name' do
    let(:params) { { index_name: index_name } }
    let(:index_name) { Elastic::IndexName.pick(rand.to_s) }

    it 'deletes index' do
      GlobalHelper.elastic_client.indices.create index: index_name
      expect(exists?(index_name)).to eq(true)
      subject
      expect(exists?(index_name)).to eq(false)
    end
  end

  describe 'when index_name is wildcard' do
    let(:params) { { index_name: Elastic::IndexName.wildcard } }

    context 'when any index exist' do
      it 'deletes all indexes' do
        expect(exists?(Elastic::IndexName.wildcard)).to eq(true)
        subject
        expect(exists?(Elastic::IndexName.wildcard)).to eq(false)
      end
    end

    context 'when there no any index' do
      it 'does not fail during remove' do
        subject
        expect(exists?(Elastic::IndexName.wildcard)).to eq(false)
        subject
      end
    end
  end

  describe '#ignore_unavailable and index is absent' do
    let(:index_name) { Elastic::IndexName.pick(rand.to_s) }

    context 'when ignore_unavailable param is false' do
      let(:params) { { index_name: index_name, ignore_unavailable: false } }

      it 'raises error because of absence of index' do
        expect { subject }.to raise_error Elasticsearch::Transport::Transport::Errors::NotFound
      end
    end

    context 'when ignore_unavailable param is true' do
      let(:params) { { index_name: index_name, ignore_unavailable: true } }

      it 'does not raise error even though absence of index' do
        expect { subject }.not_to raise_error
      end
    end
  end
end
