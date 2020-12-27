module Tableable
  extend ActiveSupport::Concern

  included do
    def get_index(additional_columns, **query_class_params)
      authorize(@settings[:singular])

      client = Elasticsearch::Client.new Rails.application.config.elastic
      context = {
          q: params[:q],
          locale: I18n.locale,
          sort: params[:sort],
          order: params[:order],
          from: (@pagination_rule.page - 1) * @pagination_rule.per,
          size: @pagination_rule.per,
          _source: @settings[:form_class].parsed_columns_for(request, current_user && current_user.role) + additional_columns,
          explain: params[:explain]
      }.merge(query_class_params)

      query = @settings[:query_class].call(context).object
      result = client.search(query)

      hits = result['hits']

      rows = Kaminari
                  .paginate_array(hits['hits'], total_count: hits['total']['value'])
                  .page(@pagination_rule.page)
                  .per(@pagination_rule.per)

      render 'empty_page' and return if rows.empty?

      favorites = Contexts::Favorites.new(current_user, rows)
      @rows = @settings[:decorator_class].decorate_collection(rows, context: { favorites: favorites })

      @columns_form = @settings[:form_class].new(
          displayed_columns: @settings[:form_class].parsed_columns_for(request, current_user && current_user.role)
      )
      render 'index', locals: { rows: @rows }
    end
  end
end
