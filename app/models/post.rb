# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id               :bigint           not null, primary key
#  comment          :text
#  currency         :integer          not null
#  extra_options    :jsonb
#  price            :decimal(, )      default(0.0), not null
#  priority         :integer          default(0), not null
#  published_at     :datetime         not null
#  status           :integer          not null
#  tags             :jsonb
#  title            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  post_category_id :bigint           not null
#  realm_id         :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_posts_on_post_category_id  (post_category_id)
#  index_posts_on_realm_id          (realm_id)
#  index_posts_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_category_id => post_categories.id)
#  fk_rails_...  (realm_id => realms.id)
#  fk_rails_...  (user_id => users.id)
#

class Post < ApplicationRecord
  enum currency: Rails.configuration.global[:currencies]
  include PostStatuses
  include Elasticable
  index_name "#{Rails.env}.posts"

  belongs_to :realm
  belongs_to :user
  belongs_to :post_category
  has_many_attached :images
  has_rich_text :body
  has_rich_text :intro

  validates :title, :status, :published_at, :tags, presence: true

  validates :tags, length: {
    minimum: 1
    # message: ->(_, __) { I18n.t('activerecord.errors.messages.select_language') }
  }

  enum status: { draft: 0, pending: 1, accrued: 2, rejected: 3, canceled: 4 }

  validate do
    next unless realm
    next if realm.news? || realm.help?

    min = 100
    errors.add(:body, :too_short, count: min) if !body || !body.body || body.body.to_plain_text.length < min
    errors.add(:intro, :too_short, count: min) if !intro || !intro.body || intro.body.to_plain_text.length < min
  end

  before_validation do
    self.currency = :usd
    # removes new lines and text like [200x200.jpg]
    self.price = body && body.body && body.body.to_plain_text
                                          .delete("\n")
                                          .gsub(/\[\d+x\d+\.\w{,5}\]/, '')
                                          .size * ExchangeRate.find_by(currency: currency, date: Date.current).value
  end

  after_save do
    next if realm.news? || realm.help?

    case status
    when 'draft'
      to_draft
    when 'pending'
      to_pending
    when 'accrued'
      to_accrued
    when 'rejected'
      to_rejected
    when 'canceled'
      to_canceled
    end
  end

  def as_indexed_json(_options = {})
    {
      id: id,
      realm_id: realm_id,
      realm_kind: realm.kind,
      realm_locale: realm.locale,
      status: status,
      title: title,
      post_category_id: post_category_id,
      post_category_title: post_category.title,
      tags: tags,
      created_at: created_at.utc,
      updated_at: updated_at.utc,
      user_id: user_id,
      intro: intro.to_s,
      body: body.to_s,
      price: price,
      currency: currency,
      priority: priority
    }
  end
end
