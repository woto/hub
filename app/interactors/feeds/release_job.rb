# frozen_string_literal: true

class Feeds::ReleaseJob
  include ApplicationInteractor

  def call
    unless context.feed
      Rails.logger.info('There are no feeds to release')
      return
    end

    result = context.feed.update(
      operation: 'release job',
      locked_by_pid: 0,
      processing_finished_at: Time.current,
      error_class: context.error&.class,
      error_text: context.error&.full_message
    )

    if result
      Rails.logger.info(context.feed)
      Rails.logger.info('Job released')
    else
      Rails.logger.info('Unable to release job')
    end
  end
end
