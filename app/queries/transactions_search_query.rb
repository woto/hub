# frozen_string_literal: true

class TransactionsSearchQuery
  include ApplicationInteractor

  contract do
    params do
      config.validate_keys = true
      required(:q).maybe(:string)
      required(:from).filled(:integer)
      required(:size).filled(:integer)
      required(:filter_ids).maybe { array? { each { string? } } }
      required(:sort).maybe(:string)
      required(:order).maybe(:string)
      required(:locale).maybe(:symbol)
    end
  end

  def call
    body = Jbuilder.new do |json|
      json.query do
        if context.filter_ids
          json.bool do
            json.must do
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
          end
        end
      end

      json.sort do
        json.set! context.sort do
          json.order context.order
        end
      end
      # sort do
      #
      # end
    end.attributes!.deep_symbolize_keys

    context.object = {}.tap do |h|
      h[:body] = body
      h[:index] = ::Elastic::IndexName.transactions
      h[:size] = context.size
      h[:from] = context.from
    end

    # context.object = {}.tap do |h|
    #   h[:body] = definition.to_hash.deep_symbolize_keys
    #   h[:index] = ::Elastic::IndexName.transactions
    #   h[:from] = context.from
    #   h[:size] = context.size
    #   h[:_source] = context._source
    # end
  end
end
