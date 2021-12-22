# frozen_string_literal: true

# TODO: to test
class IndexNowJob < ApplicationJob
  queue_as :default

  def perform(url:)
    Rails.logger.info("IndexNowJob: #{url}")
    IndexNow.call(url: url)
  end
end
