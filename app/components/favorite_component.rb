class FavoriteComponent < ViewComponent::Base
  def initialize(ext_id:, kind:, is_favorite:, starred_class:, unstarred_class:)
    @ext_id = ext_id
    @kind = kind
    @is_favorite = is_favorite
    @starred_class = starred_class
    @unstarred_class = unstarred_class
  end
end
