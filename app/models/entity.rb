# == Schema Information
#
# Table name: entities
#
#  id             :bigint           not null, primary key
#  aliases        :jsonb
#  mentions_count :integer          default(0), not null
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Entity < ApplicationRecord
  has_logidze ignore_log_data: true

  include Elasticable
  index_name "#{Rails.env}.entities"

  has_many :entities_mentions, dependent: :restrict_with_error
  has_many :mentions, through: :entities_mentions, counter_cache: :mentions_count

  has_one_attached :picture

  validates :title, presence: true

  # has_and_belongs_to_many :mentions, counter_cache: true

  def as_indexed_json(_options = {})
    {
      id: id,
      title: title,
      aliases: aliases,
      picture: picture.attached? && Rails.application.routes.url_helpers.rails_representation_path(
        picture.representation(resize_to_limit: [50, 50]), only_path: true
      ),
      created_at: created_at,
      updated_at: updated_at,
      mentions_count: mentions_count
    }
  end

  def to_label
    title
  end
end
