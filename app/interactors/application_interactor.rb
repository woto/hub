# frozen_string_literal: true

require 'active_support/concern'

module ApplicationInteractor
  extend ActiveSupport::Concern

  included do
    include Interactor

    def fail!(code: nil, message:)
      context.fail!(code: code, message: message)
    end

    def client
      Elasticsearch::Client.new(Rails.application.config.elastic)
    end

    before do
      Rails.logger.info(message: "Starting interactor", class: self.class.name)
    end

    after do
      Rails.logger.info(message: "Ending interactor", class: self.class.name)
    end
  end
end
