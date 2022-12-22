# frozen_string_literal: true

module API
  class Mentions < ::Grape::API
    prefix :api

    resource :mentions do
      params do
        optional :q, type: String, desc: 'Search string', documentation: { param_type: 'body' }
        optional :entity_ids, type: Array[Integer]
        optional :per
        optional :page
        optional :sort
      end

      post do
        @pagination_rule = PaginationRules.new(request, 5)

        query = EntityMentionsQuery.call(
          from: (@pagination_rule.page - 1) * @pagination_rule.per,
          size: @pagination_rule.per,
          q: params[:q],
          entity_ids: params[:entity_ids],
          sort: params[:sort] || 'entities.mention_date',
          order: params[:order] || 'desc'
        ).object

        result = GlobalHelper.elastic_client.search(query)

        hits = result['hits']

        rows = Kaminari
               .paginate_array(hits['hits'], total_count: hits['total']['value'])
               .page(@pagination_rule.page)
               .per(@pagination_rule.per)

        # .includes(entity: :images)
        #         'title' => entity_mention.entity.to_label,
        #         'images' => GlobalHelper.image_hash(entity_mention.entity.images),

        @favorites_store = FavoritesStore.new(current_user)

        entity_ids = Set.new
        rows.each do |row|
          row['_source']['entities'].each do |entities_mention|
            entity_ids.add(entities_mention['entity_id'])
            @favorites_store.append(entities_mention['entity_id'], 'entities')
          end
        end

        # NOTE: About order of images. I thought that having order in images_relations of Entity model affects this query
        # but it does not. So I've added additional order statement. Not sure that it's ok. But at least it works.
        query = lambda do |relation_type|
          Entity.includes(images_relations: :image)
                .where(id: entity_ids.to_a, images_relations: { relation_type: relation_type })
                .order('images_relations.order')
        end
        @entities = query.call('Entity').or(query.call(nil))

        rows.each do |row|
          row['_source']['entities'].each do |entities_mention|
            record = @entities.find { |ent| ent.id == entities_mention['entity_id'] }
            next unless record

            entities_mention['title'] = record.title
            entities_mention['images'] = GlobalHelper.image_hash(record.images_relations, %w[200 300 500 1000])
            entities_mention['is_favorite'] = @favorites_store.find(entities_mention['entity_id'], 'entities')
            entities_mention['link'] = Rails.application.routes.url_helpers.entity_url(
              record, host: GlobalHelper.host, locale: nil
            )
          end
        end

        @mentions = MentionDecorator.decorate_collection(rows)
        {
          mentions: @mentions.object,
          pagination: PaginationDecorator.call(collection: @mentions).object
        }
      end

      # get :entities do
      #   object = Interactors::Mentions::Entities.call(q: params[:q]).object
      #   object = Decorators::Mentions::Entities.call(object: object).object
      #   object
      # end
      #
      # get :urls do
      #   object = Interactors::Mentions::Urls.call(q: params[:q]).object
      #   object = Decorators::Mentions::Urls.call(object: object).object
      #   object
      # end
    end
  end
end
