# frozen_string_literal: true

module Mentions
  class EntityComponent < ViewComponent::Base
    def initialize(entity:)
      @entity = entity
    end
  end
end
