# frozen_string_literal: true

class ReindexRecordJob < ApplicationJob
  queue_as :default
  unique :until_executing, on_conflict: :log

  def perform(record)
    record.touch
  end
end
