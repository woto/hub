# frozen_string_literal: true

require 'rails_helper'

describe Extractors::YoutubeCom::ListVideosInteractor do
  subject { described_class.call(id: 'videos') }

  before do
    stub_request(:post, 'https://www.googleapis.com/oauth2/v4/token')
      .to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })

    stub_request(:get, 'https://youtube.googleapis.com/youtube/v3/videos?id=videos&maxResults=1&part=contentDetails,id,liveStreamingDetails,localizations,player,recordingDetails,snippet,statistics,status,topicDetails')
      .to_return(status: 200, body: 'youtube videos', headers: {})
  end

  it { is_expected.to have_attributes(object: 'youtube videos') }
end
