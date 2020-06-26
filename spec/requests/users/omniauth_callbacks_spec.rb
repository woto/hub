require 'rails_helper'

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

describe Users::OmniauthCallbacksController, type: :request do
  # Not sure if this needed (save and restore test_mode)
  # for now going to think that yes
  before(:all) do
    @initial_mode = OmniAuth.config.test_mode
    OmniAuth.config.test_mode = true
  end

  after(:all) do
    OmniAuth.config.test_mode = @initial_mode
  end

  before(:each) do
    OmniAuth.config.mock_auth[:facebook] = facebook_oauth
  end

  def make
    get "/users/auth/facebook/callback"
  end

  let(:facebook_oauth) { Faker::Omniauth.facebook }
  let(:provider) { 'facebook' }

  context 'when identity is new' do
    include_examples "it doesn't confirm user email"
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
      create(:identity, uid: facebook_oauth[:uid], provider: facebook_oauth[:provider], user: user)
    end

    include_examples "it doesn't confirm user email"
    include_examples "it doesn't create new user"
    include_examples "it doesn't create new identity"
    include_examples 'it updates identity auth attribute'
  end


  it "redirects to appropriate provider url when requesting /users/auth/facebook" do
    get "/users/auth/#{provider}"
    expect(response).to redirect_to("http://www.example.com/users/auth/#{provider}/callback")
  end
end
