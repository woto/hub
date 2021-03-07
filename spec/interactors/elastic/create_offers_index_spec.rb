# frozen_string_literal: true

require 'rails_helper'

describe Elastic::CreateOffersIndex do
  def exists?
    Elastic::CheckIndexExists.call(index_name: Elastic::IndexName.offers).object
  end

  it 'creates offers index with specific settings' do
    # TODO: add meta tag for skip creating index
    elastic_client.indices.delete index: ::Elastic::IndexName.wildcard

    expect(exists?).to be_falsey
    described_class.call
    expect(exists?).to be_truthy
    expect(elastic_client.indices.get(index: Elastic::IndexName.offers)).to(
      include(
        Elastic::IndexName.offers => include(
          'settings' => include(
            'index' => include(
              'refresh_interval' => '-1',
              'number_of_shards' => '10',
              'number_of_replicas' => '1'
            )
          )
        )
      )
    )
  end
end
