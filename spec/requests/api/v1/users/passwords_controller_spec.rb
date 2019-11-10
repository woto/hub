# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Users::PasswordsController, type: :request do
  describe 'request restoring' do
    context "when such email doesn't exists" do
      def make
        post '/api/v1/users/password', params: { user: { email: Faker::Internet.email } }
      end

      it "doesn't sends email" do
        expect { make }.to change(ActionMailer::Base.deliveries, :count).by(0)
      end
    end

    context 'when email valid' do
      let(:user) { create(:user) }

      def make
        post '/api/v1/users/password', params: { user: { email: user.email } }
      end

      specify 'reset_password_token empty by default' do
        expect(user.reset_password_token).to be_nil
      end

      it 'sets reset_password_token after password reset request' do
        make
        expect(user.reload.reset_password_token).not_to be_nil
      end

      it 'sends restoration email' do
        expect { make }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end

      context 'with russian subdomain' do
        before { host! "ru.nv6.ru" }

        it 'contains link to russian subdomain' do
          make
          content = ActionMailer::Base.deliveries.last.body.encoded
          expect(content).to include("https://ru.nv6.ru/reset?reset_password_token=")
        end
      end
    end
  end

  describe 'enter new password' do
    let(:password) { '12345678' }

    def make
      patch user_password_path, params: { user: {
        password: password,
        password_confirmation: password,
        reset_password_token: reset_password_token
      } }
    end

    context 'when confirmation token invalid' do
      let(:user) { create(:user) }
      let(:reset_password_token) { 'invalid reset password token' }

      it 'changes password' do
        expect { make }.not_to(change { user.reload.valid_password?(password) })
      end

      it 'returns access_token' do
        make
        expect(json_response_body).to eq('errors' => { 'reset_password_token' => ['is invalid'] })
      end
    end

    context 'when confirmation_token valid' do
      let(:user) { create(:user) }
      let(:reset_password_token) { user.send_reset_password_instructions }

      it 'changes password' do
        expect { make }.to change { user.reload.valid_password?(password) }
          .from(false)
          .to(true)
      end

      it 'returns access_token' do
        make
        expect(json_response_body).to be_like_tokenable
      end
    end
  end
end
