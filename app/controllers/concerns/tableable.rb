# frozen_string_literal: true

module Tableable
  extend ActiveSupport::Concern

  included do
    def get_index(additional_columns, **query_class_params)
      authorize(@settings[:singular])

      if params[:favorite_id]
        @favorite = policy_scope(Favorite.send(@settings[:plural])).find(params[:favorite_id])
        favorite_ids = @favorite.favorites_items.send(@settings[:plural]).pluck('ext_id')
        # NOTE: we have to filter out all entries, because none of the items exists in favorite_ids.
        # Later better do so the query even does not executes in elasticsearch.
        favorite_ids = favorite_ids.presence || [-1]
      end

      # TODO: security check filters
      context = {
        q: workspace.q,
        locale: I18n.locale,
        sort: params[:sort] || workspace.sort,
        order: params[:order] || workspace.order,
        from: @pargination_rule.from,
        size: @pagination_rule.per,
        filters: params[:filters] && params[:filters].permit!.to_h,
        favorite_ids: favorite_ids,
        model: @settings[:singular],
        _source: @settings[:form_class].parsed_columns_for(self, request, current_user && current_user.role) + additional_columns,
      }.merge(query_class_params)

      query = @settings[:query_class].call(context).object
      result = GlobalHelper.elastic_client.search(query)

      hits = result['hits']

      rows = Kaminari
             .paginate_array(hits['hits'], total_count: hits['total']['value'])
             .page(@pagination_rule.page)
             .per(@pagination_rule.per)

      raise 'favorites_kind' unless @settings.key?(:favorites_kind)
      raise 'favorites_items_kind' unless @settings.key?(:favorites_items_kind)

      @favorites_store = FavoritesStore.new(current_user)
      @favorites_store.append(rows.map { |ent| ent['_id'] }, @settings[:favorites_items_kind])

      @rows = @settings[:decorator_class].decorate_collection(rows)

      @columns_form = @settings[:form_class].new(
        model: params[:controller].split('/').last,
        state: workspace_params.to_json,
        displayed_columns: @settings[:form_class].parsed_columns_for(self, request, current_user && current_user.role)
      )
      render 'index', locals: { rows: @rows }
    end
  end
end
