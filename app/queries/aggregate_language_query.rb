# frozen_string_literal: true

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
    body = Jbuilder.new do |json|
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
            json.field "#{Import::Offers::DetectLanguage::LANGUAGE_KEY}.name.keyword"
            json.size 1
          end
        end
      end
    end

    context.object = {
      body: body.attributes!.deep_symbolize_keys,
      index: Elastic::IndexName.offers,
      size: 0,
      routing: context.feed.id
    }
  end
end
