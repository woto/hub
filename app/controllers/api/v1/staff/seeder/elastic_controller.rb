# frozen_string_literal: true

module Api
  module V1
    module Staff
      module Seeder
        # ElasticController
        class ElasticController < BaseController
          def pagination
            ::Staff::Seeder::Elastic.pagination
            head :ok
          end
        end
      end
    end
  end
end
