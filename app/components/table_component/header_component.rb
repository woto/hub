# frozen_string_literal: true

module TableComponent
  class HeaderComponent < ViewComponent::Base
    def initialize(col_name:, settings:)
      @col_name = col_name
      @settings = settings

      es = @settings[:form_class].elastic_column(col_name)
      @sort = "#{col_name}#{es[:sort]}" if es[:sort]

      @params = {
        data: { toggle: 'tooltip' },
        title: t(col_name, scope: [:table, :long, @settings[:singular]])
      }
    end
  end
end
