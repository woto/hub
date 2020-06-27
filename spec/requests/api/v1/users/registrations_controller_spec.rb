# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Users::RegistrationsController, type: :request do
  include_context 'with shared authentication'

  describe 'Registration' do
    let(:email) { Faker::Internet.email }
    let(:password) { Faker::Internet.password }

    def make
      post '/api/v1/users', params: { user: { email: email, password: password } }
    end

    it 'Creates user' do
      expect { make }.to change(User, :count).by(1)
    end

    it 'Response contains token' do
      make
      expect(json_response_body).to be_like_tokenable
    end

    example 'User is not confirmed' do
      make
      expect(User.last).not_to be_confirmed
    end

    it 'Sends a confirmation email' do
      expect { make }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    specify 'Email contains valid confirmation link' do
      make
      content = ActionMailer::Base.deliveries.first.body.encoded
      expect(content).to include("https://en.#{ENV['DOMAIN_NAME']}/confirm?confirmation_token=#{User.last.confirmation_token}")
    end

    context 'with russian subdomain' do
      before { host! "ru.#{ENV['DOMAIN_NAME']}" }

      it 'contains link to russian subdomain' do
        make
        content = ActionMailer::Base.deliveries.first.body.encoded
        expect(content).to include("https://ru.#{ENV['DOMAIN_NAME']}/confirm?confirmation_token=#{User.last.confirmation_token}")
      end
    end
  end

  describe 'Updates' do
    let(:old_email) { Faker::Internet.email }
    let(:user) { create(:user, email: old_email) }
    let(:new_password) { Faker::Internet.password }

    specify "Response doesn't contain any unexpected data" do
      xpatch '/api/v1/users', params: { user: { password: new_password } }
      expect(response).to have_http_status(:no_content)
      expect(response.body).to eq('')
    end

    describe 'Password' do
      def make
        xpatch '/api/v1/users', params: { user: { password: new_password } }
      end

      specify do
        make
        expect(user.reload.valid_password?(new_password)).to be true
      end
    end

    describe 'Email' do
      def make
        xpatch '/api/v1/users', params: { user: { email: new_email } }
      end

      context 'when new email unequal to an old email' do
        let(:new_email) { Faker::Internet.email }

        specify do
          make
          expect(user.reload.unconfirmed_email).to eq new_email
        end

        specify do
          make
          expect(user.reload.email).to eq old_email
        end

        it 'sends two emails' do
          expect do
            make
          end.to change(ActionMailer::Base.deliveries, :count).by(2)
        end

        context 'with russian subdomain' do
          before { host! "ru.#{ENV['DOMAIN_NAME']}" }

          it 'contains link to russian subdomain' do
            make
            content = ActionMailer::Base.deliveries.last.body.encoded
            expect(content).to include("https://ru.#{ENV['DOMAIN_NAME']}/confirm?confirmation_token=#{user.reload.confirmation_token}")
          end
        end
      end

      context 'when new email equal to an old email' do
        let(:new_email) { old_email }

        it 'still can rerequest confirmation' do
          make
          content = ActionMailer::Base.deliveries.last.body.encoded
          expect(content).to include("https://en.#{ENV['DOMAIN_NAME']}/confirm?confirmation_token=#{user.reload.confirmation_token}")
        end

        it 'sends only one email' do
          expect do
            make
          end.to change(ActionMailer::Base.deliveries, :count).by(1)
        end
      end
    end
  end
end
