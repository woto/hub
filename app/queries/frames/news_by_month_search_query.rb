# frozen_string_literal: true

module Frames
  class NewsByMonthSearchQuery
    include ApplicationInteractor

    def call
      body = Jbuilder.new do |json|
        json.aggregations do
          json.group_by_month do
            json.date_histogram do
              json.field 'published_at'
              json.calendar_interval '1M'
              json.order do
                json._key 'desc'
              end
            end
          end
        end

        json.query do
          json.bool do
            json.filter do
              json.array! ['fuck'] do
                json.term do
                  json.set! 'realm_id.keyword', Current.realm.id
                end
              end
              json.array! ['fuck'] do
                json.term do
                  json.set! 'status.keyword', 'accrued_post'
                end
              end
              json.array! ['fuck'] do
                json.range do
                  json.published_at do
                    json.lte Time.current.utc
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
