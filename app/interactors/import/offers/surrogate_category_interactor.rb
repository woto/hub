# frozen_string_literal: true

module Import
  module Offers
    class SurrogateCategoryInteractor
      def self.call(feed, categories_cache, parent_category = nil)
        surrogate_ext_id = "#{parent_category&.ext_id}#{Import::Offers::CategoryInteractor::SURROGATE_KEY}"
        found = categories_cache.find(ext_id: surrogate_ext_id, attempt_uuid: feed.attempt_uuid)
        return found if found

        feed_category = if parent_category
                          feed.feed_categories.children_of(parent_category)
                              .find_or_initialize_by(
                                ext_id: surrogate_ext_id,
                                ext_parent_id: parent_category.ext_id
                              )
                        else
                          feed.feed_categories.find_or_initialize_by(
                            ext_id: surrogate_ext_id
                          )
                        end

        feed_category.update!(attempt_uuid: feed.attempt_uuid)
        categories_cache.append_or_update(id: feed_category.id,
                                          ext_id: feed_category.ext_id,
                                          path_ids: feed_category.path_ids,
                                          attempt_uuid: feed.attempt_uuid)
      end
    end
  end
end
