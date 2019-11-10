# frozen_string_literal: true

module Api
  module V1
    module Staff
      module Seeder
        # Used to seed postgres for puppeteer tests
        class PostgresController < Api::V1::Staff::BaseController
          EMAIL = 'user@example.com'
          PASSWORD = '123123'
          ANOTHER_EMAIL = 'another@example.com'
          ANOTHER_PASSWORD = '321321'

          def create_user
            user = FactoryBot.create(:user, email: EMAIL, password: PASSWORD)
            respond_with user
          end

          def create_another_user
            user = FactoryBot.create(:user, email: ANOTHER_EMAIL, password: ANOTHER_PASSWORD)
            respond_with user
          end

          def create_unconfirmed_user
            user = FactoryBot.create(:user, :unconfirmed, email: EMAIL, password: PASSWORD)
            respond_with user
          end

          def create_user_without_email_and_password
            user = FactoryBot.create(:user, :without_email_and_password)
            respond_with user
          end

          def send_reset_password_instructions
            user = User.find_by(email: EMAIL)
            respond_with user.send_reset_password_instructions
          end

          def send_confirmation_instructions
            user = User.find_by(email: EMAIL)
            user.send_confirmation_instructions
            respond_with user.confirmation_token
          end
        end
      end
    end
  end
end
