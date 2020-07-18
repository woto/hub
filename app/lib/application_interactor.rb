# frozen_string_literal: true

require 'active_support/concern'

module ApplicationInteractor
  extend ActiveSupport::Concern

  included do
    include Interactor

    def fail!(code:, message:)
      context.fail!(code: code, message: message)
    end
  end
end
