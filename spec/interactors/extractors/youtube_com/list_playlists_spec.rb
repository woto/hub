# frozen_string_literal: true

require 'rails_helper'

describe Extractors::YoutubeCom::ListPlaylists do
  subject { described_class.call(id: 'playlists') }

  before do
    stub_request(:post, 'https://www.googleapis.com/oauth2/v4/token')
      .to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })

    stub_request(:get, 'https://youtube.googleapis.com/youtube/v3/playlists?id=playlists&maxResults=1&part=contentDetails,id,localizations,player,snippet,status')
      .to_return(status: 200, body: 'youtube playlists', headers: {})
  end

  it { is_expected.to have_attributes(object: 'youtube playlists') }
end
