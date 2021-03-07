# frozen_string_literal: true

module Sync
  class AdmitadJob < ApplicationJob
    queue_as :default

    def perform(*_args)
      context = Sync::Admitad::Token::Restore.call
      context = Sync::Admitad::Token::Retrieve.call if context.failure?
      Sync::Admitad::Sync.call(context)
    end
  end
end
