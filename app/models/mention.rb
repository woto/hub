# == Schema Information
#
# Table name: mentions
#
#  id               :bigint           not null, primary key
#  amount           :decimal(, )      not null
#  currency         :integer          not null
#  entities_count   :integer          default(0), not null
#  kind             :integer          not null
#  published_at     :datetime
#  sentiment        :integer          not null
#  status           :integer          not null
#  tags             :jsonb
#  url              :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  exchange_rate_id :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_mentions_on_exchange_rate_id  (exchange_rate_id)
#  index_mentions_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (exchange_rate_id => exchange_rates.id)
#  fk_rails_...  (user_id => users.id)
#
class Mention < ApplicationRecord
  has_logidze ignore_log_data: true

  include Elasticable
  index_name "#{Rails.env}.mentions"

  enum currency: GlobalHelper.currencies_table
  enum kind: { text: 0, image: 1, audio: 2, video: 3 }
  enum sentiment: { positive: 0, negative: 1, neutral: 2 }
  enum status: {
    draft_mention: 0,
    pending_mention: 1,
    approved_mention: 2,
    rejected_mention: 3,
    accrued_mention: 4,
    canceled_mention: 5,
    removed_mention: 6
  }

  belongs_to :user, counter_cache: true
  belongs_to :exchange_rate, counter_cache: true

  # has_and_belongs_to_many :entities
  has_many :entities_mentions
  has_many :entities, through: :entities_mentions, counter_cache: :entities_count
  has_many :transactions, as: :obj

  has_one_attached :screenshot

  before_validation :set_exchange_rate

  validates :entities, :amount, :status, :url, :tags, :sentiment, :kind, presence: true
  validates :tags, length: { minimum: 2 }
  validates :entities, length: { minimum: 1 }
  validates :currency, inclusion: { in: Rails.configuration.available_currencies }
  validates :url, uniqueness: true
  validate :check_currency_value

  after_save :create_transactions
  before_destroy :stop_destroy

  def as_indexed_json(options={})
    {
      id: id,
      amount: amount,
      kind: kind,
      published_at: published_at,
      sentiment: sentiment,
      status: status,
      tags: tags,
      url: url,
      created_at: created_at,
      updated_at: updated_at,
      user_id: user_id,
      screenshot: screenshot.attached? && Rails.application.routes.url_helpers.polymorphic_path(screenshot, only_path: true),
      entity_ids: entity_ids,
      entities: entities.map(&:title),
      currency: currency,
      entities_count: entities_count,
      exchange_rate_id: exchange_rate_id
    }
  end

  private

  def set_exchange_rate
    self.exchange_rate = ExchangeRate.pick(created_at)
  end

  def check_currency_value
    return if errors.include?(:currency)
    return if exchange_rate.get_currency_value(currency).positive?

    errors.add(:currency, :no_rate, currency: currency, date: (created_at || Time.current).utc.to_date)
  end

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
