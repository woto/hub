# frozen_string_literal: true

module Api
  module V1
    module Staff
      module Cropper
        class ElasticController < Api::V1::Staff::BaseController
          def crop
            ::Staff::Cropper::Elastic.crop
          end
        end
      end
    end
  end
end
