class AggregateLanguageQuery
  include ApplicationInteractor

  class Contract < Dry::Validation::Contract
    params do
      config.validate_keys = true
      required(:feed).value(type?: Feed)
    end
  end

  before do
    result = Contract.new.call(context.to_h)
    raise result.inspect if result.failure?
  end

  def call
    body = Jbuilder.encode do |json|
      json.query do
        json.term do
          json.feed_id do
            json.value context.feed.id
          end
        end
      end

      json.aggs do
        json.group do
          json.terms do
            json.field "#{Import::Offers::Language::LANGUAGE_KEY}.name.keyword"
            json.size 1
          end
        end
      end
    end

    context.object = {}.tap do |h|
      h[:body] = body
      h[:index] = ::Elastic::IndexName.offers
      h[:size] = 0
      h[:routing] = context.feed.id
    end
  end
end
