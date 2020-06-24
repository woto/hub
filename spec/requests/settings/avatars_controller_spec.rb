require 'rails_helper'

describe Settings::AvatarsController, type: :request do
  subject(:request) do
    put '/settings/avatar', params: {
      file: fixture_file_upload('files/avatar.png')
    }
  end

  let(:user) {
    FactoryBot.create(:user)
  }

  before do
    sign_in user
  end

  context 'when authenticated' do

    context 'when user without avatar' do
      specify do
        request
        expect(response).to have_http_status(:no_content)
      end

      specify do
        request
        expect(response.body).to eq('')
      end

      it 'uploads an avatar' do
        request
        expect(user.avatar).to be_attached
      end
    end
  end

  xcontext 'when not authenticated' do
  end
end
