# frozen_string_literal: true

module Import
  class LockFeed
    include ApplicationInteractor
    include Sidekiq::Util

    def call
      ActiveRecord::Base.transaction do
        fetch_feed!
        lock_feed!
      end
    end

    private

    def fetch_feed!
      context.object = FetchFeedQuery.call!(feed: context.feed).object.first

      if context.object
        Rails.logger.info(message: 'Selected feed', feed_id: context.object.id)
      else
        Rails.logger.info(message: 'No suitable feeds were found')
        context.fail!
      end
    end

    def lock_feed!
      unless context.object.is_active?
        Rails.logger.info(message: 'Feed is inactive', feed_id: context.object.id)
        context.fail!
      end

      unless context.object.advertiser.is_active?
        Rails.logger.info(message: 'Advertiser is inactive', advertiser_id: context.object.advertiser.id)
        context.fail!
      end

      context.object.update!(
        operation: 'lock feed',
        locked_by_tid: "#{identity}:#{tid}",
        attempt_uuid: SecureRandom.uuid,
        processing_started_at: Time.current,
        error_class: nil,
        error_text: nil,
        priority: 0
      )

      Rails.logger.info(message: 'Locked feed', feed_id: context.object.id)
    end
  end
end
