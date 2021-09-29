# frozen_string_literal: true

class PurgeUnattachedJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    ActiveStorage::Blob.unattached
                       .where('active_storage_blobs.created_at <= ?', 2.days.ago)
                       .find_each(&:purge_later)
  end
end
