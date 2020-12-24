# frozen_string_literal: true

# == Schema Information
#
# Table name: feed_logs
#
#  id                                 :bigint           not null, primary key
#  feed_advertiser_id_after           :bigint
#  feed_advertiser_id_before          :bigint
#  feed_advertiser_updated_at_after   :datetime
#  feed_advertiser_updated_at_before  :datetime
#  feed_attempt_uuid_after            :uuid
#  feed_attempt_uuid_before           :uuid
#  feed_categories_count_after        :integer
#  feed_categories_count_before       :integer
#  feed_created_at_after              :datetime
#  feed_created_at_before             :datetime
#  feed_data_after                    :jsonb
#  feed_data_before                   :jsonb
#  feed_downloaded_file_size_after    :bigint
#  feed_downloaded_file_size_before   :bigint
#  feed_downloaded_file_type_after    :string
#  feed_downloaded_file_type_before   :string
#  feed_error_class_after             :string
#  feed_error_class_before            :string
#  feed_error_text_after              :text
#  feed_error_text_before             :text
#  feed_ext_id_after                  :string
#  feed_ext_id_before                 :string
#  feed_id_after                      :bigint
#  feed_id_before                     :bigint
#  feed_index_name_after              :string
#  feed_index_name_before             :string
#  feed_is_active_after               :boolean
#  feed_is_active_before              :boolean
#  feed_language_after                :string
#  feed_language_before               :string
#  feed_locked_by_pid_after           :integer
#  feed_locked_by_pid_before          :integer
#  feed_name_after                    :string
#  feed_name_before                   :string
#  feed_network_updated_at_after      :datetime
#  feed_network_updated_at_before     :datetime
#  feed_offers_count_after            :integer
#  feed_offers_count_before           :integer
#  feed_operation_after               :string
#  feed_operation_before              :string
#  feed_priority_after                :string
#  feed_priority_before               :string
#  feed_processing_finished_at_after  :datetime
#  feed_processing_finished_at_before :datetime
#  feed_processing_started_at_after   :datetime
#  feed_processing_started_at_before  :datetime
#  feed_succeeded_at_after            :datetime
#  feed_succeeded_at_before           :datetime
#  feed_synced_at_after               :datetime
#  feed_synced_at_before              :datetime
#  feed_updated_at_after              :datetime
#  feed_updated_at_before             :datetime
#  feed_url_after                     :string
#  feed_url_before                    :string
#  feed_xml_file_path_after           :string
#  feed_xml_file_path_before          :string
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  feed_id                            :bigint           not null
#
# Indexes
#
#  index_feed_logs_on_feed_id  (feed_id)
#
# Foreign Keys
#
#  fk_rails_...  (feed_id => feeds.id)
#
require 'rails_helper'

RSpec.describe FeedLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end