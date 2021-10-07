class ReindexRecordJob < ApplicationJob
  queue_as :default

  def perform(record)
    record.touch
  end
end
