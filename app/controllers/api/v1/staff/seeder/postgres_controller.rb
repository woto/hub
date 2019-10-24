# frozen_string_literal: true

module Api
  module V1
    module Staff
      module Seeder
        class PostgresController < Api::V1::Staff::BaseController
          def create_user
            user = FactoryBot.create(:user, email: 'user@example.com', password: '123123')
            respond_with user
          end
        end
      end
    end
  end
end
