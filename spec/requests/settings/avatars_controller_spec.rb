# frozen_string_literal: true

require 'rails_helper'

describe Settings::AvatarsController, type: :request do
  subject(:make) do
    put '/settings/avatar', params: {
      file: fixture_file_upload('files/avatar.png')
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
