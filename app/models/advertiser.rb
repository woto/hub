# frozen_string_literal: true

# == Schema Information
#
# Table name: advertisers
#
#  id          :bigint           not null, primary key
#  feeds_count :integer          default(0), not null
#  is_active   :boolean          default(TRUE), not null
#  name        :string
#  network     :integer
#  raw         :text
#  synced_at   :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  ext_id      :string
#
# Indexes
#
#  index_advertisers_on_network_and_ext_id  (network,ext_id) UNIQUE
#
class Advertiser < ApplicationRecord
  has_one_attached :picture
  has_logidze ignore_log_data: true

  enum network: { admitad: 0, gdeslon: 1 }

  has_many :feeds, dependent: :destroy
  has_many :accounts, as: :subjectable

  validates :name, presence: true

  def slug
    [id, ActiveSupport::Inflector.transliterate(name, locale: :ru).parameterize].join('-')
  end

  def to_label
    name
  end

  def to_long_label
    name
  end

  def as_indexed_json(_options = {})
    {
      id: id,
      picture: if picture.attached?
                 if picture.variable?
                   # ApplicationController.helpers.image_tag(picture.variant(resize: '180', only_path: true), style: 'max-width: 180px')
                   ApplicationController.helpers.image_tag(
                     Rails.application.routes.url_helpers.rails_representation_path(
                      picture.representation(resize_to_limit: [100, 40]), only_path: true
                    ), style: 'max-width: 100px'
                   )
                 elsif picture.image?
                   ApplicationController.helpers.image_tag(
                     Rails.application.routes.url_helpers.rails_blob_path(
                       picture, only_path: true
                     ), style: 'max-width: 100px')
                 end

               end,
      network: network,
      ext_id: ext_id,
      name: name,
      raw: raw,
      synced_at: synced_at,
      is_active: is_active,
      feeds_count: feeds_count,
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
