# frozen_string_literal: true

module Mentions
  class IndexInteractor
    include ApplicationInteractor

    contract do
      params do
        config.validate_keys = true

        required(:params).maybe do
          hash do
            optional(:mentions_search_string).maybe(:str?)
            optional(:page_url).maybe(:str?)
            optional(:mention_id).maybe(Types::ForceInteger)
            optional(:listing_id).maybe(Types::ForceInteger)
            # optional(:entity_ids).maybe { array(:integer).each(Types::ForceInteger) }
            optional(:entity_ids).maybe(Types::Array.of(Types::ForceInteger))
            optional(:per).maybe(Types::ForceInteger)
            optional(:page).maybe(Types::ForceInteger)
            # optional(:sort).maybe(:str?)
            # optional(:order).maybe(:str?)
          end
        end
        optional(:current_user)
      end
    end

    def call
      key = [
        context.params[:mentions_search_string],
        context.params[:page_url],
        context.params[:mention_id],
        context.params[:listing_id],
        context.params[:entity_ids],
        context.params[:per],
        context.params[:page]
      ]

      cached = Rails.cache.fetch(key, expires_in: 10.seconds) do
        required_entity_ids = context.params[:entity_ids]

        if context.params[:listing_id]
          optional_entity_ids = Favorite.find(context.params[:listing_id]).favorites_items.pluck(:ext_id)
        end

        if context.params[:mention_id]
          optional_entity_ids = Mention.find(context.params[:mention_id]).entities.pluck(:id)
        end
        pagination_rule = PaginationRules.new(
          page: context.params[:page],
          per: context.params[:per],
          default_per: 5
        )

        query = IndexQuery.call(
          from: pagination_rule.from,
          size: pagination_rule.per,
          mentions_search_string: context.params[:mentions_search_string],
          page_url: context.params[:page_url],
          optional_entity_ids:,
          required_entity_ids:,
          mention_id: context.params[:mention_id]
          # sort: context.params[:sort] || 'entities.mention_date',
          # order: context.params[:order] || 'desc'
        ).object

        # puts JSON.pretty_generate(query)

        result = GlobalHelper.elastic_client.search(query)

        context.rows = Kaminari
               .paginate_array(result['hits']['hits'], total_count: result['hits']['total']['value'])
                       .page(pagination_rule.page)
                       .per(pagination_rule.per)

        # .includes(entity: :images)
        #         'title' => entity_mention.entity.to_label,
        #         'images' => GlobalHelper.image_hash(entity_mention.entity.images),

        favorites_store
        entity_ids
        entities
        enrich_rows
        set_screenshot

        next {
          mentions: context.rows,
          pagination: PaginationPresenter.call(collection: context.rows).object
        }
      end

      context.object = cached
    end

    private

    def favorites_store
      @favorites_store ||= begin
        params = {}.tap do |h|
          if context.params[:listing_id]
            h[:listing_id] = context.params[:listing_id]
          else
            # NOTE: temporary workaround for not to show favorites of one user to others users or anonymous
            h[:user] = context.current_user || -1
          end
        end

        store = FavoritesStore.new(**params)

        entity_ids.each do |entity_id|
          store.append(entity_id, 'entities')
        end

        store
      end
    end

    def entity_ids
      @entity_ids ||= begin
        set = Set.new

        context.rows.each do |row|
          row['_source']['entities'].each do |entities_mention|
            set.add(entities_mention['entity_id'])
          end
        end

        set
      end
    end

    def entities
      @entities ||= begin
        # NOTE: About order of images. I thought that having order in images_relations of Entity model affects this query
        # but it does not. So I've added additional order statement. Not sure that it's ok. But at least it works.
        query = lambda do |relation_type|
          Entity.includes(images_relations: :image)
                .where(id: entity_ids.to_a, images_relations: { relation_type: })
                .order('images_relations.order')
        end
        result = query.call('Entity').or(query.call(nil))

        result
      end
    end

    def enrich_rows
      context.rows.each do |row|
        row['_source']['entities'].each do |entities_mention|
          record = entities.find { |ent| ent.id == entities_mention['entity_id'] }
          next unless record

          entities_mention['title'] = record.title
          entities_mention['images'] = GlobalHelper.image_hash(record.images_relations, %w[200])
          entities_mention['is_favorite'] = favorites_store.find(entities_mention['entity_id'], 'entities')
          entities_mention['link'] = Rails.application.routes.url_helpers.entity_path(record)
        end
      end
    end

    def set_screenshot
      context.rows.each do |row|
        next unless row['_source']['image'].nil?

        mention = Mention.where(url: 'https://system').first_or_create! do |m|
          m.build_user(email: 'system@system', password: rand)
        end

        unless mention.image
          ImagesRelation.create!(
            relation: mention,
            image: Image.create!(
              image: File.open('./app/assets/images/chrome-mac-light.png', 'rb')
            )
          )
          mention.reload
        end

        row['_source']['image'] = GlobalHelper.image_hash(
          [mention.image_relation], %w[50 100 200 300 500 1000]
        )
      end
    end
  end
end
