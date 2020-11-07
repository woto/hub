# frozen_string_literal: true

require 'active_support/concern'

module ApplicationInteractor
  extend ActiveSupport::Concern

  included do
    include Interactor

    def fail!(code: nil, message:)
      context.fail!(code: code, message: message)
    end

    before do
      Rails.logger.info("Starting interactor #{self.class.name}")
    end
  end
end
