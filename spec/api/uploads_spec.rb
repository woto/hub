# frozen_string_literal: true

require 'rails_helper'

describe API::Uploads, type: :request do
  let!(:user) { create(:user) }

  def responses_with_uploaded_file
    expect(response.parsed_body).to match(
      'data' => match(
        'id' => end_with('.png'),
        'storage' => 'cache',
        'metadata' => include(
          'filename' => end_with('.png'),
          'size' => 1751,
          'mime_type' => 'image/png',
          'duration' => 0.0,
          'bitrate' => 0,
          'resolution' => '191x264',
          # 'frame_rate' => nil,
          'width' => 191,
          'height' => 264
        )
      ),
      'image_url' => start_with('/derivations/image/image/200/200/'),
      'video_url' => nil
    )
  end

  context 'when file passed as link' do
    it 'uploads file' do
      stub_request(:get, 'https://example.com/avatar.png')
        .to_return(body: file_fixture('avatar.png'), status: 200)

      post '/api/uploads',
           headers: { 'HTTP_API_KEY' => user.api_key },
           params: { src: 'https://example.com/avatar.png' }

      responses_with_uploaded_file
    end
  end

  context 'when file passed as a binary' do
    it 'uploads file' do
      post '/api/uploads',
           headers: { 'HTTP_API_KEY' => user.api_key },
           params: { file: fixture_file_upload('avatar.png') }

      responses_with_uploaded_file
    end
  end
end

# TODO: update rspec-rails gem and replace to fixture_file_upload
# https://github.com/rspec/rspec-rails/issues/2430
# include ActiveSupport::Testing::FileFixtures
# file: fixture_file_upload('files/avatar.png')
# file: Rack::Test::UploadedFile.new(file_fixture('avatar.png'))
