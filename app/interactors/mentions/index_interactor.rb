# frozen_string_literal: true

module Mentions
  class IndexInteractor
    include ApplicationInteractor

    def call
      q = context.params[:q]
      entity_ids = context.entity_ids
      per = context.params[:per]
      page = context.params[:page]
      sort = context.params[:sort]
      order = context.params[:order]

      pagination_rule = PaginationRules.new(context.request, 5)

      query = EntityMentionsQuery.call(
        from: (pagination_rule.page - 1) * pagination_rule.per,
        size: pagination_rule.per,
        q:,
        entity_ids:,
        sort: sort || 'entities.mention_date',
        order: order || 'desc'
      ).object

      result = GlobalHelper.elastic_client.search(query)

      hits = result['hits']

      rows = Kaminari
             .paginate_array(hits['hits'], total_count: hits['total']['value'])
             .page(pagination_rule.page)
             .per(pagination_rule.per)

      # .includes(entity: :images)
      #         'title' => entity_mention.entity.to_label,
      #         'images' => GlobalHelper.image_hash(entity_mention.entity.images),

      favorites_store = FavoritesStore.new(context.current_user)

      entity_ids = Set.new
      rows.each do |row|
        row['_source']['entities'].each do |entities_mention|
          entity_ids.add(entities_mention['entity_id'])
          favorites_store.append(entities_mention['entity_id'], 'entities')
        end
      end

      # NOTE: About order of images. I thought that having order in images_relations of Entity model affects this query
      # but it does not. So I've added additional order statement. Not sure that it's ok. But at least it works.
      query = lambda do |relation_type|
        Entity.includes(images_relations: :image)
              .where(id: entity_ids.to_a, images_relations: { relation_type: })
              .order('images_relations.order')
      end
      entities = query.call('Entity').or(query.call(nil))

      rows.each do |row|
        row['_source']['entities'].each do |entities_mention|
          record = entities.find { |ent| ent.id == entities_mention['entity_id'] }
          next unless record

          entities_mention['title'] = record.title
          entities_mention['images'] = GlobalHelper.image_hash(record.images_relations, %w[200 300 500 1000])
          entities_mention['is_favorite'] = favorites_store.find(entities_mention['entity_id'], 'entities')
          entities_mention['link'] = Rails.application.routes.url_helpers.entity_url(
            record, host: GlobalHelper.host, locale: nil
          )
        end
      end

      mentions = MentionDecorator.decorate_collection(rows)

      context.object = {
        mentions: mentions.object,
        pagination: PaginationDecorator.call(collection: mentions).object
      }
    end
  end
end
