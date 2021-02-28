# frozen_string_literal: true

module Import
  module Sync
    class AdmitadJob < ApplicationJob
      queue_as :default

      def perform(*_args)
        context = Networks::Admitad::Token::Restore.call
        context = Networks::Admitad::Token::Retrieve.call if context.failure?
        Networks::Admitad::Sync.call(context)
      end
    end
  end
end
