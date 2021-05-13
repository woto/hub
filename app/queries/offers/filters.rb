# frozen_string_literal: true

module Offers
  class Filters
    include ApplicationInteractor
    delegate :json, to: :context

    contract do
      params do
        config.validate_keys = true
        required(:json)
        required(:filter_by).maybe(:string)
        required(:filter_id).maybe { array? { each { string? } } }
      end
    end



    def call
      context.object = _filter
    end

    private

    def _filter
      if context.filter_id.present?
        json.set! :filter do
          json.array! ['fuck'] do
            json.terms do
              json.set! context.filter_by, context.filter_id
            end
          end
        end
      end
    end
  end
end
