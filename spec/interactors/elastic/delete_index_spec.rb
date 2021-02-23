# frozen_string_literal: true

require 'rails_helper'

describe Elastic::DeleteIndex do
  def exists?(index_name)
    Elastic::CheckIndexExists.call(index_name: index_name, allow_no_indices: false).object
  end

  describe 'when index_name is wildcard' do
    subject { described_class.call(index_name: Elastic::IndexName.wildcard) }

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

  # describe '#ignore_unavailable' do
  #   context 'when ignore_unavailable param is true' do
  #
  #     context 'when index exists' do
  #       before do
  #         elastic_client.indices.create index: index_name
  #       end
  #
  #       it 'deletes index' do
  #         zzz
  #       end
  #     end
  #
  #     context 'when index does not exist' do
  #       it 'succeed' do
  #
  #       end
  #     end
  #   end
  # end
end
