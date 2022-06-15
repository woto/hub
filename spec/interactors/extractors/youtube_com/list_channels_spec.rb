# frozen_string_literal: true

require 'rails_helper'

describe Extractors::YoutubeCom::ListChannels do
  subject { described_class.call(id: 'channels') }

  before do
    stub_request(:post, 'https://www.googleapis.com/oauth2/v4/token')
      .to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })

    stub_request(:get, 'https://youtube.googleapis.com/youtube/v3/channels?id=channels&maxResults=1&part=brandingSettings,contentDetails,contentOwnerDetails,id,localizations,snippet,statistics,status,topicDetails')
      .to_return(status: 200, body: 'youtube channels', headers: {})
  end

  it { is_expected.to have_attributes(object: 'youtube channels') }
end
