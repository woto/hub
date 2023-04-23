# frozen_string_literal: true

module Sync
  class AdmitadJob < ApplicationJob
    queue_as :default

    def perform(*_args)
      context = Sync::Admitad::Token::RestoreInteractor.call
      context = Sync::Admitad::Token::RetrieveInteractor.call if context.failure?
      Sync::Admitad::SyncInteractor.call(context)
    end
  end
end
