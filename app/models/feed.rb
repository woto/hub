# frozen_string_literal: true

# == Schema Information
#
# Table name: feeds
#
#  id                     :bigint           not null, primary key
#  advertiser_updated_at  :datetime
#  attempt_uuid           :uuid
#  categories_count       :integer
#  data                   :jsonb
#  downloaded_file_size   :bigint
#  downloaded_file_type   :string
#  error_class            :string
#  error_text             :text
#  is_active              :boolean          default(TRUE), not null
#  language               :string
#  locked_by_pid          :integer          default(0), not null
#  name                   :string           not null
#  network_updated_at     :datetime
#  offers_count           :integer
#  operation              :string           not null
#  priority               :integer          default(0), not null
#  processing_finished_at :datetime
#  processing_started_at  :datetime
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
  include Elasticable
  # include Elasticsearch::Model::Callbacks
  index_name "#{Rails.env}.feeds"

  belongs_to :advertiser
  has_many :feed_categories, dependent: :destroy
  has_many :feed_logs, dependent: :destroy
  after_save :log_changes

  validates :url, :name, :operation, presence: true

  validates :operation, inclusion: { in: [
    'manual', 'sync', 'sweep', 'pick job', 'release feed', 'download', 'detect file type', 'preprocess',
    'detect language', 'success'
  ] }

  def as_indexed_json(_options = {})
    adv = advertiser.as_json(methods: :type)
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

  private

  def log_changes
    fl = FeedLog.new(feed_id: id)

    Feed.column_names.each do |col_name|
      fl["feed_#{col_name}_before"], fl["feed_#{col_name}_after"] =
        public_send("#{col_name}_previous_change")
    end

    fl.save!
  end
end
