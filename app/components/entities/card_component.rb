# frozen_string_literal: true

class Entities::CardComponent < ViewComponent::Base
  def initialize(entity_id:, is_main:, image:, title:, intro:, lookups:, assignable:, controllable:, form_id:)
    super
    @entity_id = entity_id
    @is_main = is_main
    @image = image
    @title = title
    @intro = intro
    @lookups = lookups
    @assignable = assignable
    @controllable = controllable
    @form_id = form_id
  end
end
