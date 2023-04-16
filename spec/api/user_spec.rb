# frozen_string_literal: true

require 'rails_helper'

describe API::User, type: :request do
  let!(:user) { create(:user, :with_profile, :with_avatar) }

  describe 'GET /api/user/me' do
    it 'returns info about me' do
      get '/api/user/me', headers: { 'HTTP_API_KEY' => user.api_key }
      expect(response).to have_http_status(:ok)
      image = GlobalHelper.image_hash([user.avatar_relation].compact, %w[100]).first
      expect(JSON.parse(response.body)).to match(
        'id' => user.id,
        'role' => user.role,
        # 'posts_count' => user.posts_count,
        # 'checks_count' => user.checks_count,
        # 'favorites_count' => user.favorites_count,
        # 'workspaces_count' => user.workspaces_count,
        # 'profiles_count' => user.profiles_count,
        # 'identities_count' => user.identities_count,
        'api_key' => user.api_key,
        # # 'mentions_count' => user.mentions_count,
        # 'entities_count' => user.entities_count,
        # 'log_data' => nil
        'avatar' => {
          'id' => image['id'],
          'image_url' => image['images']['100']
        },
        'bio' => user.profile.bio,
        'email' => user.email,
        'languages' => user.profile.languages,
        'messengers' => user.profile.messengers,
        'name' => user.profile.name,
        'time_zone' => user.profile.time_zone,
        'unconfirmed_email' => user.unconfirmed_email,
        'created_at' => satisfying { |val| expect(Time.parse(val)).to be_within(1.second).of(user.created_at) }
      )
    end

    context 'when user is not authorized' do
      it 'returns error' do
        get '/api/user/me',
            headers: { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq('error' => 'You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when API key is incorrect' do
      it 'returns error' do
        get '/api/user/me',
            headers: { 'API-KEY' => '123', 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Invalid API key. Use API-KEY header or api_key query string parameter.'
        )
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/user/change_profile' do
    context 'when user is not authorized' do
      it 'returns error' do
        post '/api/user/change_profile',
             headers: { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq('error' => 'You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when API key is incorrect' do
      it 'returns error' do
        post '/api/user/change_profile',
             headers: { 'API-KEY' => '123', 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Invalid API key. Use API-KEY header or api_key query string parameter.'
        )
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when params is valid' do
      it 'updates profile and responses successfully' do
        post '/api/user/change_profile', headers: { 'HTTP_API_KEY' => user.api_key }, params: {
          name: '',
          bio: '',
          time_zone: '',
          languages: '',
          messengers: '',
          avatar: nil
        }

        expect(response).to have_http_status(:no_content)
        expect(response.body).to be_empty
      end
    end
  end

  describe 'POST /api/user/change_email' do
    context 'when user is not authorized' do
      it 'returns error' do
        post '/api/user/change_email',
             headers: { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq('error' => 'You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when API key is incorrect' do
      it 'returns error' do
        post '/api/user/change_email',
             headers: { 'API-KEY' => '123', 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Invalid API key. Use API-KEY header or api_key query string parameter.'
        )
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when email is already taken' do
      before do
        create(:user, email: 'already_taken@fake.com')
      end

      it 'returns error' do
        post '/api/user/change_email', headers: { 'HTTP_API_KEY' => user.api_key },
                                       params: { new_email: 'already_taken@fake.com' }
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body).to eq({ 'error' => { params: { new_email: ['has already been taken'] } }.to_json })
      end
    end

    context 'when params are correct' do
      it 'responses successfully' do
        post '/api/user/change_email', headers: { 'HTTP_API_KEY' => user.api_key },
          params: { new_email: 'foo@bar.com' }
        expect(response).to have_http_status(:no_content)
        expect(response.parsed_body).to be_empty
      end
    end
  end

  describe 'POST /api/user/regenerate_api_key' do
    context 'when user is not authorized' do
      it 'returns error' do
        post '/api/user/regenerate_api_key',
             headers: { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq('error' => 'You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when API key is incorrect' do
      it 'returns error' do
        post '/api/user/regenerate_api_key',
             headers: { 'API-KEY' => '123', 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Invalid API key. Use API-KEY header or api_key query string parameter.'
        )
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when auth is valid' do
      it 'returns new api_token' do
        post '/api/user/regenerate_api_key', headers: { 'HTTP_API_KEY' => user.api_key }
        expect(response.parsed_body).to eq(user.reload.api_key)
      end
    end
  end

  describe 'POST /api/user/change_password' do
    context 'when user is not authorized' do
      it 'returns error' do
        post '/api/user/change_password',
             headers: { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq('error' => 'You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when API key is incorrect' do
      it 'returns error' do
        post '/api/user/change_password',
             headers: { 'API-KEY' => '123', 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Invalid API key. Use API-KEY header or api_key query string parameter.'
        )
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when auth and params are valid' do
      it 'returns with success' do
        post '/api/user/change_password', headers: { 'HTTP_API_KEY' => user.api_key },
                                          params: { new_password: 'qweasdzxc', password_confirmation: 'qweasdzxc' }
        expect(response).to have_http_status(:no_content)
        expect(response.parsed_body).to eq('')
        expect(user.reload.valid_password?('qweasdzxc')).to be_truthy
      end
    end
  end
end
