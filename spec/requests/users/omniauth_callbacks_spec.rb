# frozen_string_literal: true

require 'rails_helper'

describe Users::OmniauthCallbacksController, type: :request do
  RSpec.shared_examples "it doesn't create new identity" do
    specify do
      expect { make }.not_to change(Identity, :count)
    end
  end

  RSpec.shared_examples "it doesn't create new user" do
    specify do
      expect { make }.not_to change(User, :count)
    end
  end

  RSpec.shared_examples 'it creates new identity' do
    specify do
      expect { make }.to change(Identity, :count).by(1)
    end
  end

  RSpec.shared_examples 'it creates new user' do
    specify do
      expect { make }.to change(User, :count).by(1)
    end
  end

  RSpec.shared_examples "it doesn't confirm user email" do
    specify do
      make
      expect(User.last).not_to be_confirmed
    end
  end

  RSpec.shared_examples 'it confirms user email' do
    specify do
      make
      expect(User.last).to be_confirmed
    end
  end

  RSpec.shared_examples 'it updates identity auth attribute' do
    specify do
      expect { make }.to(change { identity.reload.auth })
    end
  end

  # Not sure if this needed (save and restore test_mode)
  # for now going to think that yes
  before(:all) do
    @initial_mode = OmniAuth.config.test_mode
    OmniAuth.config.test_mode = true
  end

  after(:all) do
    OmniAuth.config.test_mode = @initial_mode
  end

  def make
    get '/users/auth/facebook/callback'
  end

  context 'when unsuccessful' do
    before do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    end

    it 'redirects back on login page' do
      make
      expect(response).to redirect_to('http://www.example.com/en/auth/login')
    end
  end

  context 'when successful' do
    before do
      OmniAuth.config.mock_auth[:facebook] = facebook_oauth
    end

    let(:facebook_oauth) { Faker::Omniauth.facebook }
    let(:provider) { 'facebook' }

    it 'redirects to appropriate provider url when requesting /users/auth/facebook' do
      get "/users/auth/#{provider}"
      expect(response).to redirect_to("http://www.example.com/users/auth/#{provider}/callback")
    end

    context 'when identity is new' do
      include_examples 'it confirms user email'
      include_examples 'it creates new user'
      include_examples 'it creates new identity'

      it 'binds new identity' do
        make
        expect(Identity.last.user).to eq User.last
      end
    end

    context 'when identity already exists' do
      let!(:user) { create(:user, :unconfirmed) }
      let!(:identity) do
        create(:identity, uid: facebook_oauth[:uid], provider: facebook_oauth[:provider], user:)
      end

      include_examples 'it confirms user email'
      include_examples "it doesn't create new user"
      include_examples "it doesn't create new identity"
      include_examples 'it updates identity auth attribute'
    end
  end
end
