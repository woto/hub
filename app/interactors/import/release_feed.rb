# frozen_string_literal: true

module Import
  class ReleaseFeed
    include ApplicationInteractor

    def call
      unless context.feed
        Rails.logger.info(message: 'There are no feeds to release')
        return
      end

      result = context.feed.update(
        operation: 'release feed',
        locked_by_tid: '',
        processing_finished_at: Time.current,
        error_class: context.error&.class,
        error_text: context.error&.full_message
      )

      if result
        Rails.logger.info(message: 'Feed released', feed_id: context.feed.id)
      else
        Rails.logger.info(message: 'Unable to release feed', feed_id: context.feed.id)
      end
    end
  end
end
