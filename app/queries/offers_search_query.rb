# frozen_string_literal: true

class OffersSearchQuery
  include ApplicationInteractor

  class Contract < Dry::Validation::Contract
    params do
      config.validate_keys = true
      required(:q).maybe(:string)
      required(:from).filled(:integer)
      required(:size).filled(:integer)
      required(:group_by).maybe(:string)
      required(:filter_id).maybe { array? { each { string? } } }
      required(:include).maybe { array? { each { string? } } }
      required(:filter_by).maybe(:string)
    end
  end

  before do
    result = Contract.new.call(context.to_h)
    raise result.inspect if result.failure?
  end

  def call
    body = Jbuilder.new do |json|
      json.query do
        json.bool do
          Offers::Filters.call(
            json: json,
            filter_by: context.filter_by,
            filter_id: context.filter_id
          ).object

          Offers::SearchString.call(
            json: json,
            q: context.q
          ).object
        end
      end

      Offers::Group.call(
        json: json,
        group_by: context.group_by,
        include: context.include
      ).object
    end.attributes!.deep_symbolize_keys

    context.object = {}.tap do |h|
      h[:body] = body
      h[:index] = ::Elastic::IndexName.offers
      h[:size] = context.size
      h[:from] = context.from
      # TODO: Change to advertiser? It does not work for now.
      h[:routing] = context.feed_id if context.feed_id.present?
    end
  end
end

# TODO: vendors aggregation
# json.aggs do
#   json.vendors do
#     json.terms do
#       json.field 'vendor.#.keyword'
#       json.size 30
#     end
#   end
# end

# TODO: prices
# json.aggs do
#   json.max_price do
#     json.max do
#       json.field 'price.#.keyword'
#     end
#   end
# end

# TODO: prices
# json.aggs do
#   json.min_price do
#     json.min do
#       json.field 'price.#.keyword'
#     end
#   end
# end
