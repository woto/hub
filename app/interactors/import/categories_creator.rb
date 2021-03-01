
module Import
  class CategoriesCreator
    include ApplicationInteractor
    attr_accessor :total_count

    def initialize(context)
      @total_count = 0
      @feeds_categories_ids = []
      super
    end

    def append(doc)
      name = doc.text
      ext_id = doc.attributes['id'].value
      ext_parent_id = doc.attributes['parentId']&.value

      feed_category = context.feed.feed_categories.find_or_initialize_by(ext_id: ext_id)
      feed_category.update!(name: name, ext_parent_id: ext_parent_id)

      @feeds_categories_ids << feed_category.id
      @total_count += 1
    end

    def flush
      FeedCategory.where(id: @feeds_categories_ids).update_all(attempt_uuid: context.feed.attempt_uuid)
    end
  end
end
