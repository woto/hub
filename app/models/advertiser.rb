# frozen_string_literal: true

# == Schema Information
#
# Table name: advertisers
#
#  id         :bigint           not null, primary key
#  is_active  :boolean          default(TRUE), not null
#  name       :string
#  network    :string
#  raw        :text
#  synced_at  :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ext_id     :string
#
# Indexes
#
#  index_advertisers_on_network_and_ext_id  (network,ext_id) UNIQUE
#
class Advertiser < ApplicationRecord
  has_logidze ignore_log_data: true

  enum network: { admitad: 0, gdeslon: 1 }

  has_many :feeds, dependent: :destroy
  has_many :accounts, as: :subject

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
end
