# frozen_string_literal: true

class FavoritesStore
  def initialize(current_user)
    @current_user = current_user
    @searched_items = []
    super()
  end

  def append(ext_id, favorite_item_kind)
    @searched_items << { ext_id: ext_id, favorite_item_kind: favorite_item_kind }
  end

  def find(needle_id, needle_favorite_item_kind)
    # TODO: make parameters validation better with dry contract
    favorite_item_kind = FavoritesItem.kinds[needle_favorite_item_kind.to_s]
    raise "kind `#{needle_favorite_item_kind.inspect}` is not defined in FavoritesItem" unless favorite_item_kind

    execute_query.any? { |fi| fi.ext_id == needle_id.to_s && fi.favorite_item_kind == favorite_item_kind }
  end

  private

  def execute_query
    return @execute_query if defined?(@execute_query)

    @execute_query = []
    grouped_items = @searched_items.group_by { |item| item[:favorite_item_kind] }
    relation = FavoritesItemPolicy::Scope.new(@current_user, FavoritesItem).resolve

    # NOTE: We group by favorites_items.ext_id and favorites_items.kind for getting know if requested ext_id at
    # least exists in one favorite list. That means that we will highlight it's star.
    query = relation.select('DISTINCT ON (ext_id, favorites_items.kind) ext_id, favorites_items.kind as favorite_item_kind')

    wheres = grouped_items.map do |favorite_item_kind, ext_ids|
      {
        kind: favorite_item_kind,
        ext_id: ext_ids.map { _1[:ext_id] }
      }
    end

    query.where!(wheres[0])

    wheres[1..].each do |where|
      query.public_send(:or!, relation.where(where))
    end

    @execute_query = query.to_a
  end
end
