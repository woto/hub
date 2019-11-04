# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Users::BindsController, type: :request do
  let(:key) { SecureRandom.hex }
  let(:auth) { Faker::Omniauth.linkedin }

  before do
    redis = Redis.new(Rails.configuration.redis_oauth)
    redis.set(key, auth.to_json)
  end

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

  RSpec.shared_examples 'it contains token' do
    specify do
      make
      expect(json_response_body).to be_like_tokenable
    end
  end

  RSpec.shared_examples "it unbinds identity from another_user" do
    specify do
      make
      expect(identity.reload.user).not_to eq another_user.reload
    end
  end


  RSpec.shared_examples "it doesn't unbind identity from another_user" do
    specify do
      make
      expect(identity.reload.user).to eq another_user.reload
    end
  end

  RSpec.shared_examples 'it rebinds identity to user maked request' do
    specify do
      expect(identity.reload.user).not_to eq user
      make
      expect(identity.reload.user).to eq user
    end
  end

  RSpec.shared_examples 'it rebinds identity to newly created user' do
    specify do
      make
      expect(identity.reload.user).to eq User.last
    end
  end

  RSpec.shared_examples "it doesn't confirm user email" do
    specify do
      make
      expect(User.last).not_to be_confirmed
    end
  end

  RSpec.shared_examples 'it updates identity auth attribute' do
    specify do
      expect { make }.to(change { identity.reload.auth })
    end
  end

  context 'when user not authenticated yet' do
    def make
      patch "/api/v1/users/binds/#{key}"
    end

    context 'when identity is new' do
      include_examples 'it contains token'
      include_examples "it doesn't confirm user email"
      include_examples 'it creates new user'
      include_examples 'it creates new identity'

      it 'binds new identity' do
        make
        expect(Identity.last.user).to eq User.last
      end
    end

    context 'when identity already exists and belongs to another user' do
      let!(:another_user) { create(:user, :unconfirmed) }
      let!(:identity) do
        create(:identity, uid: auth['uid'],
                          provider: auth['provider'],
                          user: another_user)
      end

      include_examples 'it contains token'
      include_examples "it doesn't confirm user email"
      include_examples "it doesn't create new user"
      include_examples "it doesn't create new identity"
      include_examples "it doesn't unbind identity from another_user"
      include_examples 'it rebinds identity to newly created user'
      include_examples 'it updates identity auth attribute'

      it 'authenticates as newly created user' do
        make
        credentials = Doorkeeper::AccessToken.find_by(
          token: json_response_body['access_token']
        )
        expect(credentials.resource_owner_id).to eq(User.last.id)
      end
    end
  end

  context 'when user already authenticated' do
    def make
      xpatch "/api/v1/users/binds/#{key}"
    end

    include_context 'with shared authentication' do
      let!(:user) { create(:user, :unconfirmed, email: "getting@example.com") }
    end

    context 'when identity is new' do
      include_examples 'it contains token'
      include_examples "it doesn't confirm user email"
      include_examples "it doesn't create new user"
      include_examples 'it creates new identity'

      it 'binds new identity' do
        make
        expect(Identity.last.user).to eq user
      end
    end

    context 'when identity already exists' do
      let!(:another_user) { create(:user, :unconfirmed, email: "giving@example.com", ) }
      let!(:identity) do
        create(:identity, uid: auth['uid'],
                          provider: auth['provider'],
                          user: another_user)
      end

      include_examples 'it contains token'
      include_examples "it doesn't confirm user email"
      include_examples "it doesn't create new user"
      include_examples "it doesn't create new identity"
      include_examples "it unbinds identity from another_user"
      include_examples 'it rebinds identity to user maked request'
      include_examples 'it updates identity auth attribute'
    end
  end
end
