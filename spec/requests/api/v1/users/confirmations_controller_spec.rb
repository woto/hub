# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Users::ConfirmationsController, type: :request do
  def make
    get "/api/v1/users/confirmation?confirmation_token=#{token}"
  end

  context 'when confirmation_token valid' do
    let(:user) { create(:user, :unconfirmed) }
    let(:token) { user.confirmation_token }

    it { expect(user.confirmation_token).to be_present }
    it { expect(user.confirmed_at).to be_nil }

    it 'returns access_token' do
      make
      expect(json_response_body).to be_like_tokenable
    end

    it "doesn't clean up confirmation_token after confirmation" do
      make
      expect(user.reload.confirmation_token).not_to be_nil
    end

    it 'sets confirmed_at after confirmation' do
      make
      expect(user.reload.confirmed_at).to be_within(0.1).of(Time.zone.now)
    end

    context 'when email already confirmed' do
      it 'returns error' do
        user.confirm
        make
        expect(json_response_body).to eq('email' => ['E-mail was already confirmed, please try signing in'])
      end
    end
  end

  context 'when confirmation_token invalid' do
    let(:token) { '123' }

    it "doesn't returns access_token" do
      make
      expect(json_response_body).not_to be_like_tokenable
    end

    it 'returns error' do
      make
      expect(json_response_body).to eq('confirmation_token' => ['Confirmation link is invalid'])
    end
  end
end
