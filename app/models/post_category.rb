# frozen_string_literal: true

# == Schema Information
#
# Table name: post_categories
#
#  id         :bigint           not null, primary key
#  ancestry   :string
#  priority   :integer          default(0), not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  realm_id   :bigint           not null
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
  include Elasticable
  index_name "#{Rails.env}.post_categories"

  belongs_to :realm

  validates :title, presence: true

  validate do
    next if parent.nil?

    errors.add(:realm_id, 'must be same realm_id') if realm_id != parent.realm_id
    # TODO: must have same realm_id
  end

  validate do
    # TODO: can not have any associated posts if it is not leaf
    # add validation on adding children
  end

  has_ancestry

  def as_indexed_json(_options = {})
    categories_in_path = PostCategory.unscoped.find(path_ids)
    path = path_ids[0...-1].map do |path_id|
      categories_in_path.find { |category| category.id == path_id }
    end

    {
      id: id,
      # title_i18n: title_i18n,
      title: title,
      # TODO: Bugreport or fix it.
      # Next line doesn't work without overriding path above.
      # It makes wrong sql query with `WHERE ancestry = '...'` condition
      path: path.map(&:title),
      realm_id: realm_id,
      realm_title: realm.title,
      realm_locale: realm.locale,
      realm_kind: realm.kind,
      leaf: children.none?,
      priority: priority
    }
  end

  after_save do
    parent&.touch
  end
end
