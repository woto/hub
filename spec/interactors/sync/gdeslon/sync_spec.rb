# frozen_string_literal: true

require 'rails_helper'

describe Sync::Gdeslon::SyncInteractor do
  before do
    stub_request(:get, "https://www.gdeslon.ru/api/users/shops.xml?api_token=#{ENV.fetch('GDESLON_TOKEN')}")
      .to_return(
        status: 200,
        body: file_fixture('syncs/responses/gdeslon_advertisers_small.xml')
      )
  end

  it 'does not raise error' do
    expect { described_class.call }.not_to raise_error
  end

  it 'creates advertisers' do
    expect { described_class.call }.to change(Advertiser, :count).by(2)
  end
end
