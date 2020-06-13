# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::AvatarsController, type: :request do
  include_context 'with shared authentication'

  def make
    xpatch '/api/v1/avatar', params: {
      avatar: fixture_file_upload('avatar.png')
    }
  end

  context 'when user without avatar' do
    xspecify do
      make
      expect(response).to have_http_status(:no_content)
    end

    xspecify do
      make
      expect(response.body).to eq('')
    end

    xit 'uploads an avatar' do
      make
      expect(user.avatar).to be_attached
    end
  end

  context 'when user with avatar' do
    let(:user) { create(:user, :with_avatar) }

    xspecify do
      xget '/api/v1/avatar'
      expect(json_response_body['data']['attributes']).to match(
        'url' => an_instance_of(String),
      )
    end
  end
end
