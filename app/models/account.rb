# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id               :bigint           not null, primary key
#  amount           :decimal(, )      default(0.0), not null
#  code             :integer          not null
#  currency         :integer          not null
#  subjectable_type :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  subjectable_id   :bigint           not null
#
# Indexes
#
#  account_set_uniqueness                                 (code,currency,subjectable_id,subjectable_type) UNIQUE
#  index_accounts_on_subjectable_type_and_subjectable_id  (subjectable_type,subjectable_id)
#
class Account < ApplicationRecord
  has_logidze ignore_log_data: true

  include AccountIdentifiable

  include Elasticable
  index_name "#{Rails.env}.accounts"

  belongs_to :subjectable, polymorphic: true

  # belongs_to :for_user,
  #            -> { joins(:accounts).where(accounts: { subjectable_type: 'User' }) },
  #            foreign_key: 'subjectable_id',
  #            class_name: 'User', optional: true

  enum currency: GlobalHelper.currencies_table
  enum code: { draft_post: 0, pending_post: 1, approved_post: 2, rejected_post: 3, accrued_post: 4,
               canceled_post: 5, pending_check: 6, approved_check: 7, payed_check: 8,
               removed_post: 9, removed_check: 10 }

  before_validation :set_amount_to_zero, on: :create

  attr_readonly :code, :currency, :subjectable_id, :subjectable_type, :amount
  validates :amount, :code, :currency, :subjectable, presence: true
  validates :currency, uniqueness: { scope: %i[code subjectable_id subjectable_type] }
  validate :restrict_change_fields, if: :persisted?

  has_many :transactions_as_credit, class_name: 'Transaction', foreign_key: :credit_id
  has_many :transactions_as_debit, class_name: 'Transaction', foreign_key: :debit_id

  scope :subjects, -> { where(subjectable_type: 'Subject') }

  def as_indexed_json(_options = {})
    {
      id: id,
      amount: amount,
      code: code,
      currency: currency,
      subjectable_id: subjectable_id,
      subjectable_type: subjectable_type,
      subjectable_label: subjectable.to_label,
      created_at: created_at,
      updated_at: updated_at
    }
  end

  def to_label
    label = ''
    label += if subjectable.is_a?(Subject)
               subjectable.to_label
             else
               subjectable.class.name.underscore
             end
    label += ", #{code}, #{currency}"
    label
  end

  def self.available_to_request(user, currency)
    # accounts = if subjectables.is_a?(User)
    #              Account.joins(:for_user).where(
    #                code: %i[accrued_post pending_check payed_check],
    #                for_user: { id: subjectables.id }, currency: currency
    #              ).to_a
    #            else
    #              Account.joins(:for_subject).where(
    #                code: %i[accrued_post pending_check payed_check],
    #                for_subject: { id: subjectables.pluck(:id) }, currency: currency
    #              ).to_a
    #            end
    #
    # amount_by_code = ->(code) { accounts.find { |account| account.code == code }&.amount || 0 }
    #
    # amount_by_code.call('accrued_post') -
    #   amount_by_code.call('pending_check') -
    #   amount_by_code.call('payed_check')

    Account.for_user(user, :accrued_post, currency).amount -
      Account.for_user(user, :approved_check, currency).amount -
      Account.for_user(user, :pending_check, currency).amount -
      Account.for_user(user, :payed_check, currency).amount
  end

  private

  def set_amount_to_zero
    self.amount = 0
  end

  def restrict_change_fields
    changed_attributes.keys.each do |field|
      errors.add(field, :readonly)
    end
  end
end
