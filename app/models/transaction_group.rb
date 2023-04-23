# frozen_string_literal: true

# == Schema Information
#
# Table name: transaction_groups
#
#  id         :bigint           not null, primary key
#  kind       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class TransactionGroup < ApplicationRecord
  enum kind: {
    'accounting/main/change_status': 0
  }

  has_many :transactions

  def self.start(kind, &block)
    self.create!(kind: kind.name.underscore.delete_suffix('_interactor')).tap(&block)
  end
end
