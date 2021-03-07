# frozen_string_literal: true

module Sync
  class GdeslonJob < ApplicationJob
    queue_as :default

    def perform(*_args)
      Sync::Gdeslon::Sync.call
    end
  end
end
