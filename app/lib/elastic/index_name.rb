# frozen_string_literal: true

module Elastic
  class IndexName
    class << self
      def pick(name)
        IndexStruct.new(name: name, scoped: "#{Rails.env}.#{name}")
      end
    end
  end
end
