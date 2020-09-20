# frozen_string_literal: true

require 'rails_helper'

describe Networks::Admitad::Token::Retrieve do
  let(:body) do
    {
      client_id: '7d2aa22417cce0f405a1fd72fe16cb',
      client_secret: '37e5e3ff364d9b470b3b4d6cd4237d',
      grant_type: 'client_credentials', 'scope' => 'advcampaigns_for_website public_data'
    }
  end

  let(:to_return) do
    {
      status: 200,
      body: JSON.dump({ access_token: '123' }),
      headers: { content_type: 'application/json' }
    }
  end

  let(:headers) do
    {
      Authorization: 'Basic N2QyYWEyMjQxN2NjZTBmNDA1YTFmZDcyZmUxNmNiOjM3ZTVlM2ZmMzY0ZDliNDcwYjNiNGQ2Y2Q0MjM3ZA=='
    }
  end

  before do
    stub_request(:post, 'https://api.admitad.com/token/')
        .with(body: body, headers: headers)
        .to_return(to_return)
  end

  it 'stores token to cache' do
    to_check = -> { Rails.cache.read(Networks::Admitad::Token::TOKEN_KEY) }
    expect { described_class.call }.to change(&to_check).from(nil).to('123')
  end

  it 'returns context.token with token' do
    expect(described_class.call).to have_attributes(token: '123')
  end
end
