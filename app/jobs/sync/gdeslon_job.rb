# frozen_string_literal: true

module Sync
  class GdeslonJob < ApplicationJob
    queue_as :default

    def perform(*_args)
      Sync::Gdeslon::SyncInteractor.call
    end
  end
end
