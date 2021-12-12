# frozen_string_literal: true

class ArticlesSearchQuery
  include ApplicationInteractor

  contract do
    params do
      # TODO: make it later?
      # config.validate_keys = true
      required(:q).maybe(:string)
      required(:from).filled(:integer)
      required(:size).filled(:integer)
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

            json.array! ['fuck!'] do
              json.term do
                json.set! 'realm_id.keyword', Current.realm.id
              end
            end

            json.array! ['fuck!'] do
              json.term do
                json.set! 'status.keyword', 'accrued_post'
              end
            end

            json.array! ['fuck!'] do
              json.range do
                json.published_at do
                  json.lte Time.current.utc
                end
              end
            end

            if context.tag.present?
              json.array! ['fuck'] do
                json.term do
                  json.set! 'tags.keyword', context.tag
                end
              end
            end

            json.array! ['fuck!'] do
              json.term do
                if context.post_category_id.present?
                  post_category = PostCategory.find(context.post_category_id)
                  json.set! "post_category_id_#{post_category.ancestry_depth}", context.post_category_id.to_i
                end
              end
            end

            if context.month.present?
              json.array! ['fuck!'] do
                json.range do
                  json.published_at do
                    json.gte context.month.beginning_of_month.utc
                    json.lte context.month.end_of_month.utc
                  end
                end
              end
            end
          end

          if context.q.present?
            json.must do
              json.array! ['fuck!'] do
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
      h[:index] = Elastic::IndexName.pick('posts').scoped
      h[:size] = context.size
      h[:from] = context.from
      h[:_source] = context._source
    end
  end
end
