# == Schema Information
#
# Table name: post_categories
#
#  id         :bigint           not null, primary key
#  ancestry   :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_post_categories_on_ancestry  (ancestry)
#
class PostCategory < ApplicationRecord
  include Elasticable
  index_name "#{Rails.env}.post_categories"

  has_ancestry

  def as_indexed_json(options = {})
    {
        id: id,
        title: title,
        path: path.map(&:title),
        leaf: children.none?
    }
  end
end
