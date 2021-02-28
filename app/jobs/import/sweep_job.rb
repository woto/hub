# frozen_string_literal: true

module Import
  class SweepJob < ApplicationJob
    def perform
      Import::Sweep.call
    end
  end
end
