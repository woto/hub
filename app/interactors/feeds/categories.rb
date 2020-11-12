# frozen_string_literal: true

module Feeds
  class Categories
    include ApplicationInteractor

    def call
      FeedCategory.where(feed: context.feed).find_each do |child|
        if child.ext_parent_id
          parent = FeedCategory.find_by(feed: context.feed,
                                        ext_id: child.ext_parent_id)
          if parent && parent != child
            child.update!(parent: parent,
                          parent_not_found: false,
                          attempt_uuid: context.feed.attempt_uuid)
          else
            child.update!(parent_not_found: true,
                          attempt_uuid: context.feed.attempt_uuid)
          end
        end
      end
    end
  end
end
