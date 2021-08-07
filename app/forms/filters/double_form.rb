# frozen_string_literal: true

module Filters
  class DoubleForm < BaseForm
    attr_accessor :min, :max

    validates :min, :max, presence: true
  end
end
