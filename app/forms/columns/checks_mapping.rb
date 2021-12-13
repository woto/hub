# frozen_string_literal: true

module Columns
  class ChecksMapping < BaseMapping
    DEFAULTS = %w[user_id amount status created_at updated_at].freeze

    self.all_columns = [
        { key: 'amount',              pg: Check.columns_hash['amount'], roles: ['user', 'manager', 'admin'] },
        { key: 'status',              pg: Check.columns_hash['status'], as: :string, roles: ['user', 'manager', 'admin'] },
        { key: 'user_id',             pg: Check.columns_hash['user_id'], roles: ['manager', 'admin'] },
        { key: 'created_at',          pg: Check.columns_hash['created_at'], roles: ['user', 'manager', 'admin'] },
        { key: 'updated_at',          pg: Check.columns_hash['updated_at'], roles: ['user', 'manager', 'admin'] },
    ]
  end
end
