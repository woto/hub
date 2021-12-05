# frozen_string_literal: true

class Entities::CardComponent < ViewComponent::Base
  def initialize(entity_id:, image:, title:, lookups:, assignable:, controllable:, form_id:)
    super
    @entity_id = entity_id
    @image = image
    @title = title
    @lookups = lookups
    @assignable = assignable
    @controllable = controllable
    @form_id = form_id
  end
end
