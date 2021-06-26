class StarFavoriteComponent < ViewComponent::Base
  def initialize(ext_id:, favorites_items_kind:, is_favorite:, bobber:)
    super
    @ext_id = ext_id
    @favorites_items_kind = favorites_items_kind
    @is_favorite = is_favorite
    @bobber = bobber
  end
end
