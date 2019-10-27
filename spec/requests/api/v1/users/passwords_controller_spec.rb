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

      it 'sends restoration email' do
        expect { make }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end

      it 'contains valid restore link' do
        # TODO: rewrite with dynamic host
        make
        content = ActionMailer::Base.deliveries.first.body.encoded
        expect(content).to include("https://nv6.ru/reset?reset_password_token=#{user.reset_password_token}")
      end
    end
  end
end
