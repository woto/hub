# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Users::RegistrationsController,
         type: :request, include_shared: true do
  describe 'registration' do
    let(:email) { Faker::Internet.email }
    let(:password) { Faker::Internet.password }

    def make
      post '/api/v1/users', params: { user: { email: email, password: password } }
    end

    it 'creates user' do
      expect { make }.to change(User, :count).by(1)
    end

    it 'sends a confirmation email' do
      expect { make }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it 'contains valid confirmation link' do
      # TODO: rewrite with dynamic host
      make
      content = ActionMailer::Base.deliveries.first.body.encoded
      expect(content).to include("https://nv6.ru/confirm?confirmation_token=#{User.last.confirmation_token}")
    end
  end

  describe 'changes' do
    let(:user) { create(:user) }
    let(:new_password) { Faker::Internet.password }

    describe 'password' do
      def make
        xpatch '/api/v1/users', params: { user: { password: new_password } }
      end

      it do
        make
        expect(user.reload.valid_password?(new_password)).to be true
      end
    end

    describe 'email' do
      let(:new_email) { Faker::Internet.email }

      def make
        xpatch '/api/v1/users', params: { user: { email: new_email } }
      end

      it do
        make
        expect(user.reload.unconfirmed_email).to eq new_email
      end
    end
  end
end
