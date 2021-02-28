class DeleteOldOffersQuery
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
    body = Jbuilder.new do |json|
      json.query do
        json.bool do
          json.must_not do
            json.term do
              json.set! 'attempt_uuid.keyword', context.feed.attempt_uuid
            end
          end
          json.filter do
            json.term do
              json.feed_id context.feed.id
            end
          end
        end
      end
    end

    context.object = {
      index: Elastic::IndexName.offers,
      routing: context.feed.id,
      body: body.attributes!.deep_symbolize_keys
    }
  end
end
