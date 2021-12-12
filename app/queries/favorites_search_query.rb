# frozen_string_literal: true

class FavoritesSearchQuery
  include ApplicationInteractor

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

            if context.filter_ids.present?
              json.array! ['fuck!'] do
                json.terms do
                  json.user_id context.filter_ids
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
      h[:index] = Elastic::IndexName.pick('favorites').scoped
      h[:size] = context.size
      h[:from] = context.from
      h[:_source] = context._source
    end

    # definition = search do
    #
    #   query do
    #     bool do
    #       if context.filter_ids
    #         filter do
    #           term "user_id" => context.filter_ids
    #         end
    #       end
    #
    #       if context.q.present?
    #         must do
    #           query_string do
    #             query context.q
    #           end
    #         end
    #       else
    #         filter do
    #           match_all {}
    #         end
    #       end
    #     end
    #   end
    #
    #   sort do
    #     by context.sort, order: context.order
    #   end
    # end
    #
    # context.object = {}.tap do |h|
    #   h[:body] = definition.to_hash.deep_symbolize_keys
    #   h[:index] = Elastic::IndexName.pick('favorites').scoped
    #   h[:from] = context.from
    #   h[:size] = context.size
    #   h[:_source] = context._source
    # end
  end
end
