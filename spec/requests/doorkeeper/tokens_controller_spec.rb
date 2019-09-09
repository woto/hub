# frozen_string_literal: true

require 'spec_helper'

describe Doorkeeper::TokensController, type: :request do
  def make
    post '/oauth/token', params: {
      grant_type: 'password',
      username: user.email,
      password: user.password
    }
  end

  context 'user confirmed' do
    let(:user) { create(:user) }

    it do
      make
      expect(JSON.parse(response.body)).to have_key('access_token')
    end
  end

  context "user doesn't confirmed" do
    let(:user) { create(:user, :unconfirmed) }

    it do
      make
      expect(JSON.parse(response.body)).to eq(
        'error' => 'invalid_grant',
        'error_description' => 'The provided authorization grant is invalid, expired, revoked, does not match the redirection URI used in the authorization request, or was issued to another client.'
      )
    end
  end
end
