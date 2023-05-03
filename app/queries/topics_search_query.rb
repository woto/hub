# frozen_string_literal: true

class TopicsSearchQuery
  include ApplicationInteractor

  contract do
    params do
      required(:q).maybe(:str?)
      required(:from).filled(:integer)
      required(:size).filled(:integer)
      optional(:order)
      optional(:sort)
    end
  end

  def call
    body = Jbuilder.new do |json|
      json.query do
        json.bool do
          json.must do
            json.multi_match do
              json.query context.q
              json.type 'bool_prefix'
              json.fields do
                json.array! %w[
                  title.autocomplete^2
                  title.autocomplete._2gram^2
                  title.autocomplete._3gram^2
                ]
              end
            end
          end
        end
      end

      json.sort do
        json.array! ['fuck'] do
          json.set! context.sort do
            json.order context.order
          end
        end
      end
    end

    context.object = {}.tap do |h|
      h[:body] = body.attributes!.deep_symbolize_keys
      h[:index] = Elastic::IndexName.pick('topics').scoped
      h[:size] = context.size
      h[:from] = context.from
      # h[:_source] = context._source
    end
  end
end
