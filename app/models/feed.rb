# frozen_string_literal: true

# == Schema Information
#
# Table name: feeds
#
#  id                     :bigint           not null, primary key
#  attempt_uuid           :uuid
#  categories_count       :integer          default(0), not null
#  downloaded_file_size   :bigint
#  downloaded_file_type   :string
#  error_class            :string
#  error_text             :text
#  feed_categories_count  :integer          default(0), not null
#  is_active              :boolean          default(TRUE), not null
#  language               :string
#  locked_by_pid          :integer          default(0), not null
#  name                   :string           not null
#  offers_count           :integer          default(0), not null
#  operation              :string           not null
#  priority               :integer          default(0), not null
#  processing_finished_at :datetime
#  processing_started_at  :datetime
#  raw                    :text
#  succeeded_at           :datetime
#  synced_at              :datetime
#  url                    :string           not null
#  xml_file_path          :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  advertiser_id          :bigint           not null
#  ext_id                 :string
#
# Indexes
#
#  index_feeds_on_advertiser_id  (advertiser_id)
#
# Foreign Keys
#
#  fk_rails_...  (advertiser_id => advertisers.id)
#
class Feed < ApplicationRecord
  has_logidze ignore_log_data: true
  include Elasticable
  # include Elasticsearch::Model::Callbacks
  index_name "#{Rails.env}.feeds"

  belongs_to :advertiser, counter_cache: true, touch: true
  has_many :feed_categories, dependent: :destroy

  validates :url, :name, :operation, presence: true
  validates :operation, inclusion: { in: [
    'manual', 'sync', 'sweep', 'lock feed', 'release feed', 'download', 'detect file type', 'preprocess',
    'detect language', 'success'
  ] }

  scope :active, -> { where(is_active: true).joins(:advertiser).where(advertisers: { is_active: true }) }

  def as_indexed_json(_options = {})
    adv = advertiser.as_json
    adv.transform_keys! { |k| "advertiser_#{k}" }
    as_json.merge(adv)
  end

  def file
    File.new(self)
  end

  def slug
    [id, ActiveSupport::Inflector.transliterate(name, locale: :ru).parameterize].join('-')
  end

  def slug_with_advertiser
    [advertiser.slug, slug].join('+')
  end

  def to_label
    name
  end

  def to_long_label
    "#{advertiser.to_long_label} -> #{name}"
  end
end
