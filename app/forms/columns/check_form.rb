# frozen_string_literal: true

module Columns
  class CheckForm < BaseForm
    DEFAULTS = %w[id amount is_payed payed_at created_at updated_at].freeze

    self.all_columns = [
        { key: 'id',                  pg: Check.columns_hash['id'], roles: ['guest', 'user', 'manager', 'admin'] },
        { key: 'amount',              pg: Check.columns_hash['amount'], roles: ['guest', 'user', 'manager', 'admin'] },
        { key: 'is_payed',            pg: Check.columns_hash['is_payed'], roles: ['guest', 'user', 'manager', 'admin'] },
        { key: 'payed_at',            pg: Check.columns_hash['payed_at'], roles: ['guest', 'user', 'manager', 'admin'] },
        { key: 'user_id',             pg: Check.columns_hash['user_id'], roles: ['guest', 'user', 'manager', 'admin'] },
        { key: 'created_at',          pg: Check.columns_hash['created_at'], roles: ['guest', 'user', 'manager', 'admin'] },
        { key: 'updated_at',          pg: Check.columns_hash['updated_at'], roles: ['guest', 'user', 'manager', 'admin'] },
        { key: 'user_id',             pg: Check.columns_hash['user_id'], roles: ['guest', 'user', 'manager', 'admin'] }
    ]
  end
end
