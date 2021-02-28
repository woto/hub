class Import::FeedsJob < ApplicationJob
  queue_as :low

  def perform(feed = nil)
    Import::Process.call(feed: feed)
  end
end
