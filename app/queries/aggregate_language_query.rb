# frozen_string_literal: true

class AggregateLanguageQuery
  include ApplicationInteractor

  contract do
    params do
      config.validate_keys = true
      required(:feed).value(type?: Feed)
    end
  end

  def call
    body = Jbuilder.new do |json|
      json.query do
        json.bool do
          json.filter do
            json.array! ['fuck'] do
              json.term do
                json.feed_id context.feed.id
              end
            end

            # json.array! ['fuck'] do
            #   json.term do
            #     json.set! 'detected_language.reliable', true
            #   end
            # end
          end
        end
      end

      json.aggs do
        json.group do
          json.terms do
            json.field "#{Import::Offers::DetectLanguageInteractor::LANGUAGE_KEY}.code.keyword"
            json.size 1
          end
        end
      end
    end

    context.object = {
      body: body.attributes!.deep_symbolize_keys,
      index: Elastic::IndexName.pick('offers').scoped,
      size: 0,
      routing: context.feed.id
    }
  end
end
