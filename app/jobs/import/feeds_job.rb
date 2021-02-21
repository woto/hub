class Import::FeedsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Feeds::Process.call
  end
end
