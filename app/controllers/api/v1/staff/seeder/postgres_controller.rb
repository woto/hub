# frozen_string_literal: true

module Api
  module V1
    module Staff
      module Seeder
        class PostgresController < Api::V1::Staff::BaseController
          def seed
            user = FactoryBot.create(:user)
            respond_with user
          end
        end
      end
    end
  end
end
