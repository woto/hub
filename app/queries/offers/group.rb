# frozen_string_literal: true

module Offers
  class Group
    include ApplicationInteractor
    delegate :json, to: :context

    class Contract < Dry::Validation::Contract
      params do
        config.validate_keys = true
        required(:json)
        optional(:group_by).filled(:string)
        optional(:include).maybe { array? { each { string? } } }
      end
    end

    before do
      result = Contract.new.call(context.to_h)
      raise result.inspect if result.failure?
    end

    def call
      context.object = _group
    end

    private

    def _group
      json.aggs do
        json.set! GlobalHelper::GROUP_NAME do
          json.terms do
            json.field context.group_by
            json.order do
              json.set! 'sort.sum_of_squares', 'desc'
            end
            json.size GlobalHelper::GROUP_LIMIT
            json.include context.include if context.include
          end
          json.aggs do
            json.offers do
              json.top_hits do
                json.size GlobalHelper::MULTIPLICATOR - 1
              end
            end
            json.sort do
              json.extended_stats do
                json.script do
                  json.source '_score'
                end
              end
            end
          end
        end
      end
    end
  end
end
