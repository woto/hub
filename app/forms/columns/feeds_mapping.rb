# frozen_string_literal: true

module Columns
  class FeedsMapping < BaseMapping
    DEFAULTS = %w[advertiser_name advertiser_picture name offers_count succeeded_at created_at].freeze

    self.all_columns = [
      { key: 'operation'                                       , pg: Feed.columns_hash['operation'], roles: ['admin'] },
      { key: 'ext_id'                                          , pg: Feed.columns_hash['ext_id'], roles: ['admin'] },
      { key: 'name'                                            , pg: Feed.columns_hash['name'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'url'                                             , pg: Feed.columns_hash['url'], roles: ['admin'] },
      { key: 'error_class'                                     , pg: Feed.columns_hash['error_class'], roles: ['admin'] },
      { key: 'error_text'                                      , pg: Feed.columns_hash['error_text'], roles: ['admin'] },
      { key: 'locked_by_tid'                                   , pg: Feed.columns_hash['locked_by_tid'], roles: ['admin'] },
      { key: 'languages'                                       , pg: Feed.columns_hash['languages'], roles: ['guest', 'user', 'manager', 'admin']  },
      { key: 'attempt_uuid'                                    , pg: Feed.columns_hash['attempt_uuid'], roles: ['admin'] },
      { key: 'raw'                                             , pg: Feed.columns_hash['raw'], roles: ['admin'] },
      { key: 'processing_started_at'                           , pg: Feed.columns_hash['processing_started_at'], roles: ['admin'] },
      { key: 'processing_finished_at'                          , pg: Feed.columns_hash['processing_finished_at'], roles: ['admin'] },
      { key: 'synced_at'                                       , pg: Feed.columns_hash['synced_at'], roles: ['admin'] },
      { key: 'categories_count'                                , pg: Feed.columns_hash['categories_count'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'feed_categories_count'                           , pg: Feed.columns_hash['feed_categories_count'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'offers_count'                                    , pg: Feed.columns_hash['offers_count'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'priority'                                        , pg: Feed.columns_hash['priority'], roles: ['admin'] },
      { key: 'xml_file_path'                                   , pg: Feed.columns_hash['xml_file_path'], roles: ['admin'] },
      { key: 'downloaded_file_type'                            , pg: Feed.columns_hash['downloaded_file_type'], roles: ['admin'] },
      { key: 'is_active'                                       , pg: Feed.columns_hash['is_active'], roles: ['admin'] },
      { key: 'downloaded_file_size'                            , pg: Feed.columns_hash['downloaded_file_size'], roles: ['admin'] },
      { key: 'succeeded_at'                                    , pg: Feed.columns_hash['succeeded_at'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'created_at'                                      , pg: Feed.columns_hash['created_at'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'updated_at'                                      , pg: Feed.columns_hash['updated_at'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'advertiser_id'                                   , pg: Advertiser.columns_hash['id'], roles: ['admin'] },
      { key: 'advertiser_picture'                              , pg: ActiveStorage::Blob.columns_hash['filename'], as: :string, roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'advertiser_is_active'                            , pg: Advertiser.columns_hash['is_active'], roles: ['admin'] },
      { key: 'advertiser_name'                                 , pg: Advertiser.columns_hash['name'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'advertiser_network'                              , pg: Advertiser.columns_hash['network'], as: :string, roles: ['admin'] },
      { key: 'advertiser_raw'                                  , pg: Advertiser.columns_hash['raw'], roles: ['admin'] },
      { key: 'advertiser_ext_id'                               , pg: Advertiser.columns_hash['ext_id'], roles: ['admin'] },
      { key: 'advertiser_synced_at'                            , pg: Advertiser.columns_hash['synced_at'], roles: ['admin'] },
      { key: 'advertiser_created_at'                           , pg: Advertiser.columns_hash['created_at'], roles: ['admin'] },
      { key: 'advertiser_updated_at'                           , pg: Advertiser.columns_hash['updated_at'], roles: ['admin'] },
    ]
  end
end
