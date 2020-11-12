# frozen_string_literal: true

class Feeds::Sweep
  include ApplicationInteractor

  def call
    Feed.where.not(locked_by_pid: 0).each do |feed|
      Process.getpgid(feed.locked_by_pid)
    rescue Errno::ESRCH
      feed.update(operation: 'sweep', locked_by_pid: 0)
    end
  end
end
