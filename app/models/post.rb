# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id               :bigint           not null, primary key
#  currency         :integer          not null
#  extra_options    :jsonb
#  price            :decimal(, )      not null
#  priority         :integer          default(0), not null
#  published_at     :datetime         not null
#  status           :integer          not null
#  tags             :jsonb
#  title            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  exchange_rate_id :bigint           not null
#  post_category_id :bigint           not null
#  realm_id         :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_posts_on_exchange_rate_id  (exchange_rate_id)
#  index_posts_on_post_category_id  (post_category_id)
#  index_posts_on_realm_id          (realm_id)
#  index_posts_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (exchange_rate_id => exchange_rates.id)
#  fk_rails_...  (post_category_id => post_categories.id)
#  fk_rails_...  (realm_id => realms.id)
#  fk_rails_...  (user_id => users.id)
#

class Post < ApplicationRecord
  has_logidze ignore_log_data: true

  include Elasticable
  index_name "#{Rails.env}.posts"

  enum currency: GlobalHelper.currencies_table
  enum status: { draft: 0, pending: 1, approved: 2, rejected: 3, accrued: 4, canceled: 5 }

  belongs_to :realm, counter_cache: true, touch: true
  belongs_to :user, counter_cache: true, touch: true
  belongs_to :post_category, counter_cache: true, touch: true
  belongs_to :exchange_rate, counter_cache: true, touch: true

  has_many_attached :images
  has_rich_text :body
  has_rich_text :intro

  has_many :transactions, as: :obj

  before_validation :set_exchange_rate
  before_validation :set_price

  validates :title, :status, :published_at, :tags, presence: true
  validates :tags, length: { minimum: 2 }
  validates :currency, inclusion: { in: Rails.configuration.available_currencies }
  # validates :price, numericality: { greater_than: 0 }
  validate :check_min_intro_length
  validate :check_min_body_length
  validate :check_post_category_is_leaf
  validate :check_currency_value

  after_save :create_transactions

  scope :news, -> { joins(:realm).where(realms: { kind: :news }) }

  def as_indexed_json(_options = {})
    {
      id: id,
      realm_id: realm_id,
      realm_title: realm.title,
      realm_locale: realm.locale,
      realm_kind: realm.kind,
      realm_domain: realm.domain,
      status: status,
      title: title,
      post_category_id: post_category_id,
      post_category_title: post_category.title,
      tags: tags,
      created_at: created_at.utc,
      updated_at: updated_at.utc,
      published_at: published_at.utc,
      user_id: user_id,
      intro: intro.to_s,
      body: body.to_s,
      price: price,
      currency: currency,
      priority: priority
    }
  end

  private

  def check_min_intro_length
    min = 1
    errors.add(:intro, :too_short, count: min) if !intro || !intro.body || intro.body.to_plain_text.length < min
  end

  def check_min_body_length
    min = 1
    errors.add(:body, :too_short, count: min) if Post.sanitize(body).length < min
  end

  def set_exchange_rate
    self.exchange_rate = ExchangeRate.pick(created_at)
  end

  def set_price
    return if errors.include?(:body)
    return if errors.include?(:currency)

    rate = exchange_rate.get_currency_value(currency)
    self.price = Post.sanitize(body).length * rate
  end

  def check_post_category_is_leaf
    return unless post_category&.persisted?

    errors.add(:post_category, :must_be_leaf) unless post_category.children.none?
  end

  def check_currency_value
    return if errors.include?(:currency)
    return if exchange_rate.get_currency_value(currency).positive?

    errors.add(:currency, :no_rate, currency: currency, date: (created_at || Time.current).utc.to_date)
  end

  def create_transactions
    # Any exception that is not ActiveRecord::Rollback or ActiveRecord::RecordInvalid
    # will be re-raised by Rails after the callback chain is halted.
    action = "Accounting::Posts::TransitTo#{status.camelcase}".constantize
    action.call(post: self)
  rescue ActiveRecord::ActiveRecordError => e
    puts e.backtrace
    raise e.message
  end

  class << self
    def sanitize(attribute)
      # sanitizes, removes new lines and texts like [200x200.jpg]
      ActionController::Base.helpers.sanitize(attribute.to_s, tags: [])
                            .gsub(/\[\d+x\d+\.\w{,5}\]/, '')
                            .delete("\n")
                            .strip
    end
  end
end
