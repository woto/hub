# frozen_string_literal: true

require 'rails_helper'

describe Doorkeeper::TokensController, type: :request do
  def make(email, password)
    post '/oauth/token', params: {
      grant_type: 'password',
      username: email,
      password: password
    }
  end

  context 'unexisted email' do
    let(:user) { create(:user) }

    specify do
      make("not_existing_#{user.email}", user.password)
      expect(json_response_body).to include('error' => 'not_registered')
    end
  end

  context 'when user confirmed' do
    let(:user) { create(:user) }

    it 'getting access_token' do
      make(user.email, user.password)
      # TODO: why it doesn't behave like be_like_tokenable?
      # it doesn't include refresh_token
      expect(json_response_body).to have_key('access_token')
    end

    it 'getting error if password is wrong' do
      make(user.email, "#{user.password} !")
      expect(json_response_body).to include('error' => 'wrong_password')
    end
  end

  context "user doesn't confirmed" do
    context 'when registered less than two weeks ago' do
      let(:user) { create(:user, :unconfirmed) }

      it 'getting access_token' do
        make(user.email, user.password)
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

      specify do
        make(user.email, user.password)
        expect(json_response_body).to include('error' => 'email_unconfirmed')
      end
    end
  end
end
