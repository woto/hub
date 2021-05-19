# frozen_string_literal: true

require 'active_support/concern'

module ApplicationInteractor
  extend ActiveSupport::Concern

  included do
    include Interactor

    def self.contract(&block)
      before do
        contract_class = Class.new(Dry::Validation::Contract, &block)
        contract = contract_class.new.call(context.to_h)
        raise StandardError, contract.errors.to_h.to_json if contract.failure?
      end
    end

    def fail!(message:, code: nil)
      context.fail!(code: code, message: message)
    end

    before do
      Rails.logger.info(message: "Starting interactor", class: self.class.name)
    end

    after do
      Rails.logger.info(message: "Ending interactor", class: self.class.name)
    end
  end
end
