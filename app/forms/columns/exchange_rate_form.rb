# frozen_string_literal: true

module Columns
  class ExchangeRateForm < BaseForm
    DEFAULTS = %w[].freeze

    self.all_columns = [
      { key: 'id',                  pg: ExchangeRate.columns_hash['id'], roles: ['manager', 'admin'] },
      { key: 'date',                pg: ExchangeRate.columns_hash['date'], as: :string, roles: ['manager', 'admin'] },
      { key: 'currencies',          pg: ExchangeRate.columns_hash['currencies'], as: :jsonb, roles: ['manager', 'admin'] },
      { key: 'extra_options',       pg: ExchangeRate.columns_hash['extra_options'], as: :jsonb, roles: ['manager', 'admin'] },
      { key: 'created_at',          pg: ExchangeRate.columns_hash['created_at'], roles: ['manager', 'admin'] },
      { key: 'updated_at',          pg: ExchangeRate.columns_hash['updated_at'], roles: ['manager', 'admin'] },
    ]
  end
end
