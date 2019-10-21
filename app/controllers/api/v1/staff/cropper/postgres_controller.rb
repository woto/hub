# frozen_string_literal: true

module Api
  module V1
    module Staff
      module Cropper
        class PostgresController < Api::V1::Staff::BaseController
          def crop
            DatabaseCleaner.strategy = :truncation
            DatabaseCleaner.clean
          end
        end
      end
    end
  end
end
