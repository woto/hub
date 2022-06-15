# frozen_string_literal: true

class TransactionsSearchQuery
  include ApplicationInteractor

  contract do
    params do
      # TODO: make it later?
      # config.validate_keys = true
      required(:q).maybe(:string)
      required(:from).filled(:integer)
      required(:size).filled(:integer)
      required(:filter_ids).maybe { array? { each { string? } } }
      required(:favorite_ids).maybe { array? { each { string? } } }
      required(:sort).maybe(:string)
      required(:order).maybe(:string)
      required(:locale).maybe(:symbol)
      required(:_source).filled { array? { each { string? } } }
    end
  end

  def call
    body = Jbuilder.new do |json|
      json.query do
        json.bool do
          json.filter do

            Tables::Filters.call(
              json: json,
              model: context.model,
              filters: context.filters
            ).object

            Tables::Favorites.call(
              json: json,
              model: context.model,
              favorite_ids: context.favorite_ids
            ).object

          end

          json.must do
            if context.filter_ids.present?
              json.array! ['fuck!'] do
                json.bool do
                  json.set! :should do
                    json.array! ['fuck'] do
                      json.terms do
                        json.credit_id context.filter_ids
                      end
                    end
                    json.array! ['fuck'] do
                      json.terms do
                        json.debit_id context.filter_ids
                      end
                    end
                  end
                end
              end
            end

            if context.q.present?
              json.array! ['fuck'] do
                json.query_string do
                  json.query context.q
                end
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
      h[:index] = Elastic::IndexName.pick('transactions').scoped
      h[:size] = context.size
      h[:from] = context.from
      h[:_source] = context._source
    end
  end
end
