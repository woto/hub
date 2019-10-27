# frozen_string_literal: true

require 'rails_helper'

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
      # TODO: why it doesn't behave like be_like_tokenable?
      # it doesn't include refresh_token
      expect(json_response_body).to have_key('access_token')
    end
  end

  context "user doesn't confirmed" do
    context 'when registered less than two weeks ago' do
      let(:user) { create(:user, :unconfirmed) }

      it do
        make
        # TODO: why it doesn't behave like be_like_tokenable?
        # it doesn't include refresh_token
        expect(json_response_body).to have_key('access_token')
      end
    end

    context 'when registered more than two weeks ago' do
      let(:user) do
        create(:user, :unconfirmed).tap do |u|
          u.update(confirmation_sent_at: 15.days.ago)
        end
      end

      it do
        make
        expect(json_response_body).to eq(
          'error' => 'invalid_grant',
          'error_description' => 'The provided authorization grant is invalid, expired, revoked, does not match the redirection URI used in the authorization request, or was issued to another client.'
        )
      end
    end
  end
end
