# frozen_string_literal: true

class AccountsSearchQuery
  include ApplicationInteractor

  contract do
    params do
      # TODO: make it later?
      # config.validate_keys = true
      required(:q).maybe(:string)
      required(:from).filled(:integer)
      required(:size).filled(:integer)
      required(:filter_ids).maybe { array? { each { string? } } }
      required(:sort).maybe(:string)
      required(:order).maybe(:string)
      required(:locale).maybe(:symbol)
      required(:_source).filled { array? { each { string? } } }
    end
  end

  def call
    body = Jbuilder.new do |json|
      json.query do
        Tables::Filters.call(
          json: json,
          model: context.model,
          filters: context.filters
        ).object

        json.bool do
          if context.filter_ids.present?
            json.filter do
              json.array! ['fuck!'] do
                json.term do
                  json.subjectable_id context.filter_ids
                end
              end
              json.array! ['fuck'] do
                json.term do
                  json.set! 'subjectable_type.keyword'.to_sym, 'User'
                end
              end
            end
          end

          if context.q.present?
            json.must do
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
      h[:index] = ::Elastic::IndexName.accounts
      h[:size] = context.size
      h[:from] = context.from
      h[:_source] = context._source
    end
  end
end
