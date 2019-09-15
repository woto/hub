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
      expect(JSON.parse(response.body)).to have_key('access_token')
    end
  end

  context 'when confirmation_token invalid' do
    let(:token) { '123' }

    it 'returns error' do
      make
      expect(JSON.parse(response.body)).to eq('confirmation_token' => ['is invalid'])
    end
  end

  context 'when confirmed user' do
    let(:user) { create(:user) }

    it { expect(user).to be_confirmed }
    it { expect(ActionMailer::Base.deliveries.count).to be_zero }
    it 'changes his email confirmation email sends' do
      # TODO: rewrite with dynamic host
      expect do
        user.update(email: user.email.prepend('changed_'))
      end.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end
end
