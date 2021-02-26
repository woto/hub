# frozen_string_literal: true

module Import
  module Offers
    class Category
      CATEGORY_IDS_KEY = 'feed_category_ids'
      CATEGORY_ID_KEY = 'feed_category_id'
      SURROGATE_KEY = '!'
      SURROGATE_NAME = 'surrogate'
      WRONG_CATEGORY_ERROR = -1

      class CategoryError < StandardError; end

      def self.call(offer, feed, categories)
        category_value = offer.delete('categoryId')
        raise CategoryError, 'There is no categoryId key' unless category_value
        raise CategoryError, 'There are more than one values for categoryId key' unless category_value.one?

        ext_category_id = category_value.first[Import::Offers::Hashify::HASH_BANG_KEY]
        feed_category = categories[ext_category_id]
        raise 'FeedCategory must have been found' unless feed_category

        has_children = categories.any? do |_ext_id, values|
          values.path_ids[0...-1].include?(feed_category[:id])
        end

        if has_children
          feed_category = FeedCategory.children_of(feed_category).find_or_create_by!(
            feed_id: feed.id,
            ext_id: "#{ext_category_id}#{SURROGATE_KEY}",
            ext_parent_id: ext_category_id,
            name: 'surrogate',
            parent_not_found: false
          ) do |fc|
            fc.attempt_uuid = feed.attempt_uuid
          end
        end

        set_offer_values(offer, feed_category.id, feed_category.path_ids)
      rescue CategoryError => e
        Yabeda.hub.import.increment({ feed_id: feed.id, message: e.message }, by: 1)
        set_offer_values(offer, WRONG_CATEGORY_ERROR, [WRONG_CATEGORY_ERROR])
      end

      def self.set_offer_values(offer, id_val, ids_val)
        offer[CATEGORY_ID_KEY] = id_val
        offer[CATEGORY_IDS_KEY] = ids_val
        ids_val.each_with_index.map do |id, idx|
          offer["#{CATEGORY_ID_KEY}_#{idx}"] = id
        end
      end
    end
  end
end
