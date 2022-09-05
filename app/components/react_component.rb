# frozen_string_literal: true

class ReactComponent < ViewComponent::Base
  renders_one :draft

  def initialize(name:, props:, class:)
    super
    @name = name
    @props = props
    @class = binding.local_variable_get(:class)
  end
end
