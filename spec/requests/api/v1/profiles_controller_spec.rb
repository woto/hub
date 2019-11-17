# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::ProfilesController, type: :request do
  include_context 'with shared authentication'

  def make
    xpatch '/api/v1/profile', params: {
      user: {
        name: 'name',
        bio: 'bio',
        messengers: [{ name: 'whatsapp', number: 'number' }],
        location: 'location',
        languages: ['russian']
      }
    }
  end

  context 'when user without profile' do
    it 'creates new profile' do
      expect { make }.to change(Profile, :count).by(1)
    end

    it 'successfully responses' do
      make
      expect(response).to have_http_status(:no_content)
    end

    it 'shows profile without errors' do
      xget '/api/v1/profile'
      expect(response.body).to eq('')
    end
  end

  context 'when user with profile' do
    let(:user) { create(:user, :with_profile) }

    it 'updates available profile name' do
      previous_name = user.profile.name
      make
      expect(user.profile.name).not_to eq(user.profile.reload.name)
    end

    it "doesn't create new profile" do
      make
      expect { make }.not_to change(Profile, :count)
    end

    it 'shows profile without errors' do
      xget '/api/v1/profile'
      expect(json_response_body['data']['attributes']).to match(
        'name' => an_instance_of(String),
        'bio' => an_instance_of(String),
        'languages' => an_instance_of(Array),
        'location' => an_instance_of(String),
        'messengers' => an_instance_of(Array)
      )
    end
  end
end
