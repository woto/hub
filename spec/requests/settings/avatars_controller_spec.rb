# frozen_string_literal: true

require 'rails_helper'

describe Settings::AvatarsController, type: :request do
  subject(:make) do
    put '/settings/avatar', params: {
      # TODO: update rspec-rails gem and replace to fixture_file_upload
      # https://github.com/rspec/rspec-rails/issues/2430
      # include ActiveSupport::Testing::FileFixtures
      # file: fixture_file_upload('files/avatar.png')
      file: Rack::Test::UploadedFile.new(file_fixture('avatar.png'))
    }
  end

  let(:user) do
    FactoryBot.create(:user)
  end

  before do
    sign_in user
  end

  context 'when authenticated' do
    context 'when user without avatar' do
      specify do
        make
        expect(response).to have_http_status(:no_content)
      end

      specify do
        make
        expect(response.body).to eq('')
      end

      it 'uploads an avatar' do
        make
        expect(user.avatar).to be_attached
      end
    end
  end

  xcontext 'when not authenticated' do
  end
end
