# frozen_string_literal: true

# == Schema Information
#
# Table name: checks
#
#  id           :bigint           not null, primary key
#  amount       :decimal(, )      not null
#  currency     :integer          not null
#  lock_version :integer          not null
#  status       :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_checks_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Check < ApplicationRecord
  has_logidze ignore_log_data: true
  belongs_to :user, counter_cache: true, touch: true

  include Elasticable
  # include Elasticsearch::Model::Callbacks
  index_name "#{Rails.env}.checks"

  enum currency: GlobalHelper.currencies_table
  enum status: {
    pending_check: 0,
    approved_check: 1,
    payed_check: 2,
    removed_check: 3
  }

  has_many :transactions, as: :obj

  validates :amount, numericality: { greater_than: 0 }
  validates :status, :currency, presence: true
  validate :check_amount

  after_save :create_transactions
  before_destroy :stop_destroy

  def check_amount
    return if errors.include?(:currency)
    return if errors.include?(:amount)

    available_amount = Account.available_to_request(user, currency)

    same_currency = attribute_in_database(:currency) == currency
    same_user = attribute_in_database(:user_id) == user_id
    available_amount += attribute_in_database(:amount).to_d if same_currency && same_user

    if amount >= available_amount
      count = GlobalHelper.decorate_money(available_amount - 0.01, currency)
      errors.add(:amount, :less_than_or_equal_to, count: count)
    end
  end

  def as_indexed_json(_options = {})
    {
      id: id,
      amount: amount,
      currency: currency,
      status: status,
      user_id: user_id,
      created_at: created_at,
      updated_at: updated_at
    }
  end

  private

  def create_transactions
    # Any exception that is not ActiveRecord::Rollback or ActiveRecord::RecordInvalid
    # will be re-raised by Rails after the callback chain is halted.
    Accounting::Main::ChangeStatus.call(record: self)
  rescue ActiveRecord::ActiveRecordError => e
    logger.error e.backtrace
    raise e.message
  end

  def stop_destroy
    errors.add(:base, :undestroyable)
    throw :abort
  end
end
