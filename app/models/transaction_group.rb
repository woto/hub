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
    pending_post: 0,
    accrued_post: 2,
    pending_to_accrued: 3,
    accrued_to_canceled: 4,
    accrued_to_rejected: 5,
    accrued_to_pending: 6,
    accrued_to_paid_with_yandex: 7,
    advertiser_to_hub_payed_rub: 8,
    stakeholder_to_hub: 9,
    hub_rub_to_advego_account_usd: 10,
    request_check: 11,
    pay_check: 12,
    create_or_change_pending: 13,
    rejected_to_pending: 14
  }

  has_many :transactions
end
