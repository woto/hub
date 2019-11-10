# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Users::UnbindsController, type: :request do

  include_context 'with shared authentication' do
    let(:user) do
      create(:user)
    end
  end

  let(:auth) { Faker::Omniauth.facebook }

  let!(:identity) do
    create(:identity, uid: auth[:uid],
                      provider: auth[:provider],
                      user: user)
  end

  it 'unbinds social account from user' do
    expect do
      xdelete "/api/v1/users/unbinds/facebook"
    end.to change(user.identities, :count).by(-1)
  end
end
