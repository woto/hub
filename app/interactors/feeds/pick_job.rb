# frozen_string_literal: true

class Feeds::PickJob
  include ApplicationInteractor

  def call
    ActiveRecord::Base.transaction do
      feed = Feeds::QueueQuery.call.lock.first
      if feed.present?
        feed.update!(
          operation: 'pick job',
          locked_by_pid: Process.pid,
          attempt_uuid: SecureRandom.uuid,
          processing_started_at: Time.current,
          error_class: nil,
          error_text: nil,
          priority: 0
        )
        Rails.logger.info(feed)
      else
        Rails.logger.info('No suitable jobs were found')
        context.fail!
      end

      context.feed = feed
    end
  end
end
