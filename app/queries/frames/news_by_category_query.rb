# frozen_string_literal: true

module Frames
  class NewsByCategoryQuery
    include ApplicationInteractor

    def call
      level = if context.post_category_id
                PostCategory.find_by(id: context.post_category_id)&.ancestry_depth
              else
                -1
              end

      body = Jbuilder.new do |json|
        json.aggregations do
          json.group_by_category_id do
            json.terms do
              json.field "post_category_id_#{level + 1}"
              json.size 100
            end
          end
        end

        json.query do
          json.bool do
            json.filter do
              json.array! ['fuck'] do
                json.term do
                  json.set! 'realm_kind.keyword', 'news'
                end
              end
              json.array! ['fuck'] do
                json.term do
                  json.set! 'status.keyword', 'accrued_post'
                end
              end
              json.array! ['fuck'] do
                json.term do
                  json.set! 'realm_locale.keyword', context.locale
                end
              end
              json.array! ['fuck'] do
                json.range do
                  json.published_at do
                    json.lte Time.current.utc
                  end
                end
              end
              if context.post_category_id
                json.array! ['fuck'] do
                  json.term do
                    json.set! "post_category_id_#{level}", context.post_category_id
                  end
                end
              end
            end
          end
        end
      end

      context.object = {
        index: Elastic::IndexName.posts,
        body: body.attributes!.deep_symbolize_keys,
        size: 0
      }
    end
  end
end
