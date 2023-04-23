# frozen_string_literal: true

module Import
  module Offers
    class CategoryInteractor
      CATEGORY_IDS_KEY = 'feed_category_ids'
      CATEGORY_ID_KEY = 'feed_category_id'
      SURROGATE_KEY = '!'
      SURROGATE_NAME = 'surrogate'
      WRONG_CATEGORY_ERROR = -1

      class CategoryError < StandardError
        attr_reader :object

        def initialize(object)
          @object = object
          super
        end
      end

      def self.call(offer, feed, categories)
        category_value = offer.delete('categoryId')

        raise CategoryError.new(nil), 'There is no categoryId key' unless category_value

        unless category_value.one?
          raise CategoryError.new({ categoryId: category_value }), 'There are more than one values for categoryId key'
        end

        ext_category_id = category_value.first[Import::Offers::HashifyInteractor::HASH_BANG_KEY]
        feed_category = categories.items[ext_category_id]

        raise CategoryError.new({ categoryId: ext_category_id }), 'FeedCategory was not found' unless feed_category

        has_children = categories.items.any? do |_ext_id, values|
          values.path_ids[0...-1].include?(feed_category[:id])
        end
        feed_category = Import::Offers::SurrogateCategoryInteractor.call(feed, categories, feed_category) if has_children
        set_offer_values(offer, feed_category.id, feed_category.path_ids)
      rescue CategoryError => e
        feed_category = Import::Offers::SurrogateCategoryInteractor.call(feed, categories)
        set_offer_values(offer, feed_category.id, [feed_category.id])

        Rails.logger.warn(message: e.message, feed_id: feed.id, object: e.object)
        Yabeda.hub.categories_errors.increment({ feed_id: feed.id, message: e.message }, by: 1)
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
