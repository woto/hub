# frozen_string_literal: true

module Api
  module V1
    module Staff
      module Seeder
        # Used to seed postgres for puppeteer tests
        class PostgresController < Api::V1::Staff::BaseController
          EMAIL = 'user@example.com'
          PASSWORD = '123123'

          def create_user
            user = FactoryBot.create(:user, email: EMAIL, password: PASSWORD)
            respond_with user
          end

          def create_unconfirmed_user
            user = FactoryBot.create(:user, :unconfirmed, email: EMAIL, password: PASSWORD)
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

          def get_user
            user = User.find_by(email: EMAIL)
            respond_with user.attributes.to_json
          end
        end
      end
    end
  end
end
