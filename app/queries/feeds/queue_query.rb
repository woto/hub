# frozen_string_literal: true

class Feeds::QueueQuery
  def self.call
    raise 'is it used? Feeds::QueueQuery'
    Feed
      .where(locked_by_pid: 0)
      .order('priority DESC, processing_finished_at ASC NULLS FIRST')
  end
end
