# frozen_string_literal: true

module Entities
  class GetInteractor
    include ApplicationInteractor

    def call
      if context.id.present?
        entity = Entity.find(context.id)
      else
        # TODO: optimize
        entity = Entity.order('RANDOM()').first
      end

      context.object = EntityPresenter.call(entity: entity).object
    end
  end
end
