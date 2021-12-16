# frozen_string_literal: true

module Mentions
  class EntityComponent < ViewComponent::Base
    def initialize(entity:)
      super
      @id = entity.fetch('id')
      @title = entity.fetch('title')
      is_main = entity.fetch('is_main')
      @direction = entity['direction']

      @color = if is_main
                 'blue'
               else
                 'secondary'
               end
    end
  end
end
