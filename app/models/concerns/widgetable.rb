# frozen_string_literal: true

module Widgetable
  extend ActiveSupport::Concern

  included do
    has_one :widget, as: :widgetable, touch: true
  end
end
