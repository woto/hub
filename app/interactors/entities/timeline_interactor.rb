# frozen_string_literal: true

module Types
  include Dry.Types()
end

module Entities
  class TimelineInteractor
    include ApplicationInteractor

    contract do
      params do
        required(:entity_id)
        required(:count)
      end
    end

    def call
      operations = []

      cites.each_cons(2) do |prv, cur, _nxt|
        operation = {
          id: cur.id,
          user_name: cur.user&.profile&.name || 'Имя не указано',
          user_path: '/404',
          user_image: if cur.user.avatar
                        GlobalHelper.image_hash([cur.user.avatar_relation], %w[200]).first['images']['200']
                      else
                        'https://media.istockphoto.com/photos/businessman-silhouette-as-avatar-or-default-profile-picture-picture-id476085198?b=1&k=20&m=476085198&s=170667a&w=0&h=Ct4e1kIOdCOrEgvsQg4A1qeuQv944pPFORUQcaGw4oI='
                      end,
          created_at: cur.created_at,
          relevance: cur.relevance,
          sentiment: cur.sentiment,
          link_url: cur.link_url,
          mention_url: cur.mention.url,
          mention_title: cur.mention.title,
          mention_date: cur.mention_date&.to_datetime,
          prefix: cur.prefix,
          suffix: cur.suffix,
          text_start: cur.text_start,
          text_end: cur.text_end,
          target_url: Fragment::Builder.call(
            url: cur.mention.url,
            text_start: cur.text_start,
            text_end: cur.text_end,
            prefix: cur.prefix,
            suffix: cur.suffix
          )
        }

        if prv.title != cur.title
          operation[:title] = {
            add: cur.title,
            remove: prv.title
          }
        end

        if prv.intro != cur.intro
          operation[:intro] = {
            add: cur.intro,
            remove: prv.intro
          }
        end

        # TODO: figure out how to present difference of two arrays
        if true
          operation[:images] = {
            add: GlobalHelper.image_hash(cur.images_relations - prv.images_relations, %w[50 100 200 300 500 1000]),
            remove: GlobalHelper.image_hash(prv.images_relations - cur.images_relations, %w[50 100 200 300 500 1000])
          }
        end

        if prv.topics != cur.topics
          operation[:topics] = {
            add: cur.topics - prv.topics,
            remove: prv.topics - cur.topics
          }
        end

        if prv.lookups != cur.lookups
          operation[:lookups] = {
            add: cur.lookups - prv.lookups,
            remove: prv.lookups - cur.lookups
          }
        end

        operations.append(operation)
      end

      operations_class = Types::Array.of(Entities::TimelineStruct)
      context.object = operations_class[operations].reverse
    end

    def cites
      cites = Cite.order(id: :desc)
                  .includes(:lookups, :topics, :mention, user: [:profile], images_relations: :image)
                  .limit(context.count)
      cites.where!(images_relations: { relation_type: 'Cite' })
      cites.where!(entity_id: context.entity_id)

      [Cite.new, *cites.reverse]
    end
  end
end
