# frozen_string_literal: true

require 'rails_helper'

describe Elastic::CreateOffersIndex do
  def exists?
    Elastic::CheckIndexExists.call(index: Elastic::IndexName.pick('offers')).object
  end

  it 'creates offers index with specific settings' do
    # TODO: add meta tag for skip creating index
    GlobalHelper.elastic_client.indices.delete index: Elastic::IndexName.pick('*').scoped

    expect(exists?).to be_falsey
    described_class.call
    expect(exists?).to be_truthy
    expect(GlobalHelper.elastic_client.indices.get(index: Elastic::IndexName.pick('offers').scoped)).to(
      have_attributes(
        body: include(
          Elastic::IndexName.pick('offers').scoped => include(
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
    )
  end
end
