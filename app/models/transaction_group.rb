# frozen_string_literal: true

# == Schema Information
#
# Table name: transaction_groups
#
#  id          :bigint           not null, primary key
#  kind        :integer
#  object_hash :jsonb
#  object_type :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  object_id   :bigint
#
# Indexes
#
#  index_transaction_groups_on_object_type_and_object_id  (object_type,object_id)
#
class TransactionGroup < ApplicationRecord
  enum kind: {
    pending_post: 0,
    accrued_post: 1,
    pending_to_accrued: 2,
    accrued_to_canceled: 3,
    accrued_to_rejected: 4,
    accrued_to_pending: 5,
    accrued_to_paid_with_yandex: 6,
    advertiser_to_bank: 7,
    stakeholder_to_fund: 8,
    fund_to_advego_account_usd: 9
  }

  belongs_to :object, polymorphic: true, optional: true

  has_many :transactions

  before_save do
    self.object_hash = object.attributes if object
  end

  def to_label
    kind
  end

end
