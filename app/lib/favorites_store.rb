# frozen_string_literal: true

class FavoritesStore
  attr_accessor :items

  def initialize(current_user, ext_ids, favorite_kind, favorite_item_kind)
    unless ext_ids.empty?
      # NOTE: We group by ext_id for getting know if requested ext_id exist at
      # least exists in one favorite list. That means that we will highlight it's star.
      self.items = FavoritesItemPolicy::Scope.new(current_user, FavoritesItem)
                                             .resolve
                                             .select('DISTINCT ON (ext_id) ext_id')
                                             .where(
                                               favorites: { kind: favorite_kind },
                                               kind: favorite_item_kind,
                                               ext_id: ext_ids
                                             )
    end
  end

  def find(needle_id)
    items.any? { |fi| fi.ext_id == needle_id.to_s }
  end
end
