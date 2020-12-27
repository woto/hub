class Contexts::Favorites
  attr_accessor :favorites

  def initialize(current_user, collection)
    unless collection.empty?
      kind = Elastic::IndexName.crop_environment(collection.first['_index'])
      ext_ids = collection.map { |item| item['_id'] }
      @favorites_items = FavoritesItemPolicy::Scope.new(current_user, FavoritesItem).resolve
      @favorites_items = @favorites_items.select('DISTINCT ON (ext_id) ext_id').where(favorites: { kind: kind }, ext_id: ext_ids).all
      # TODO: add distinct by ext_id
    end
  end

  def find(needle)
    @favorites_items.any? { |fi| fi.ext_id == needle._id }
  end
end
