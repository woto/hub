# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id               :bigint           not null, primary key
#  language         :string
#  price            :integer          default(0), not null
#  status           :integer          not null
#  title            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  post_category_id :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_posts_on_post_category_id  (post_category_id)
#  index_posts_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_category_id => post_categories.id)
#  fk_rails_...  (user_id => users.id)
#

class Post < ApplicationRecord
  include PostStatuses
  include Elasticable
  index_name "#{Rails.env}.posts"

  belongs_to :user
  belongs_to :post_category
  has_many_attached :images
  has_rich_text :body

  validates :title, :status, :body, :language, presence: true

  enum status: { draft: 0, pending: 1, accrued: 2, rejected: 3, canceled: 4 }
  after_save do
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
      status: status,
      title: title,
      language: language,
      post_category: post_category.title,
      created_at: created_at.utc,
      updated_at: updated_at.utc,
      user_id: user_id,
      body: body.body,
      price: price
    }
  end

  before_validation do
    # removes new lines and text like [200x200.jpg]
    self.price = body.body.to_plain_text
                     .delete("\n")
                     .gsub(/\[\d+x\d+\.\w+{,5}\]/, '')
                     .size
  end

  def to_label
    title
  end
end
