# frozen_string_literal: true

module Import
  class SweepJob < ApplicationJob
    queue_as :default

    def perform
      Import::SweepInteractor.call
    end
  end
end
