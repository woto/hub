# frozen_string_literal: true

# == Schema Information
#
# Table name: post_categories
#
#  id             :bigint           not null, primary key
#  ancestry       :string
#  ancestry_depth :integer          default(0)
#  posts_count    :integer          default(0)
#  priority       :integer          default(0), not null
#  title          :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  realm_id       :bigint           not null
#
# Indexes
#
#  index_post_categories_on_ancestry  (ancestry)
#  index_post_categories_on_realm_id  (realm_id)
#
# Foreign Keys
#
#  fk_rails_...  (realm_id => realms.id)
#
class PostCategory < ApplicationRecord
  has_logidze ignore_log_data: true

  include Elasticable
  index_name "#{Rails.env}.post_categories"

  belongs_to :realm, counter_cache: true, touch: true

  has_ancestry cache_depth: true
  has_many :posts

  validates :title, presence: true
  validate :check_same_realms
  validate :check_parent_does_not_have_posts

  after_save :touch_parent

  scope :leaves, lambda { joins("LEFT JOIN #{table_name} AS c ON c.#{ancestry_column} = CAST(#{table_name}.id AS char(50)) OR c.#{ancestry_column} = concat(#{table_name}.#{ancestry_column}, '/', #{table_name}.id)").group("#{table_name}.id").having('COUNT(c.id) = 0') }

  def as_indexed_json(_options = {})
    categories_in_path = PostCategory.unscoped.find(path_ids)
    path = path_ids[0...-1].map do |path_id|
      categories_in_path.find { |category| category.id == path_id }
    end

    {
      id: id,
      title: title,
      # TODO: Bugreport or fix it.
      # Next line doesn't work without overriding path above.
      # It makes wrong sql query with `WHERE ancestry = '...'` condition
      # feed_category, post_category
      path: path.map(&:title),
      realm_id: realm_id,
      realm_title: realm.title,
      realm_locale: realm.locale,
      realm_kind: realm.kind,
      leaf: children.none?,
      priority: priority,
      ancestry_depth: ancestry_depth,
      created_at: created_at.utc,
      updated_at: updated_at.utc,
      posts_count: posts_count
    }
  end

  private

  def check_same_realms
    return if parent.nil?

    errors.add(:realm_id, 'must have same realm_id') if realm_id != parent.realm_id
  end

  def check_parent_does_not_have_posts
    errors.add(:parent_id, 'parent must not have the posts') if parent && parent.posts.count.positive?
    # TODO: can not have any associated posts if it is not leaf
    # add validation on adding children
  end

  def touch_parent
    parent&.touch
  end
end
