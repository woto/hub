# frozen_string_literal: true

module Columns
  class UsersMapping < BaseMapping
    DEFAULTS = %w[email posts_count].freeze

    self.all_columns = [
      { key: 'confirmation_sent_at'             , pg: User.columns_hash['confirmation_sent_at'], roles: ['manager', 'admin'] },
      { key: 'confirmation_token'               , pg: User.columns_hash['confirmation_token'], roles: ['admin'] },
      { key: 'confirmed_at'                     , pg: User.columns_hash['confirmed_at'], roles: ['manager', 'admin'] },
      { key: 'current_sign_in_at'               , pg: User.columns_hash['current_sign_in_at'], roles: ['manager', 'admin'] },
      { key: 'current_sign_in_ip'               , pg: User.columns_hash['current_sign_in_ip'], roles: ['manager', 'admin'] },
      { key: 'email'                            , pg: User.columns_hash['email'], roles: ['manager', 'admin'] },
      { key: 'encrypted_password'               , pg: User.columns_hash['encrypted_password'], roles: ['admin'] },
      { key: 'failed_attempts'                  , pg: User.columns_hash['failed_attempts'], roles: ['manager', 'admin'] },
      { key: 'last_sign_in_at'                  , pg: User.columns_hash['last_sign_in_at'], roles: ['manager', 'admin'] },
      { key: 'last_sign_in_ip'                  , pg: User.columns_hash['last_sign_in_ip'], roles: ['manager', 'admin'] },
      { key: 'locked_at'                        , pg: User.columns_hash['locked_at'], roles: ['manager', 'admin'] },
      { key: 'remember_created_at'              , pg: User.columns_hash['remember_created_at'], roles: ['manager', 'admin'] },
      { key: 'reset_password_sent_at'           , pg: User.columns_hash['reset_password_sent_at'], roles: ['manager', 'admin'] },
      { key: 'reset_password_token'             , pg: User.columns_hash['reset_password_token'], roles: ['admin'] },
      { key: 'role'                             , pg: User.columns_hash['role'], as: :string, roles: ['manager', 'admin'] },
      { key: 'sign_in_count'                    , pg: User.columns_hash['sign_in_count'], roles: ['manager', 'admin'] },
      { key: 'unconfirmed_email'                , pg: User.columns_hash['unconfirmed_email'], roles: ['manager', 'admin'] },
      { key: 'unlock_token'                     , pg: User.columns_hash['unlock_token'], roles: ['admin'] },
      { key: 'created_at'                       , pg: User.columns_hash['created_at'], roles: ['manager', 'admin'] },
      { key: 'updated_at'                       , pg: User.columns_hash['updated_at'], roles: ['manager', 'admin'] },
      { key: 'profile_id'                       , pg: Profile.columns_hash['id'], roles: ['manager', 'admin'] },
      { key: 'profile_name'                     , pg: Profile.columns_hash['name'], roles: ['manager', 'admin'] },
      { key: 'profile_time_zone'                , pg: Profile.columns_hash['time_zone'], roles: ['manager', 'admin'] },
      { key: 'profile_bio'                      , pg: Profile.columns_hash['bio'], roles: ['manager', 'admin'] },
      { key: 'profile_languages'                , pg: Profile.columns_hash['languages'], as: :string, roles: ['manager', 'admin'] },
      { key: 'profile_messengers'               , pg: Profile.columns_hash['messengers'], roles: ['manager', 'admin'] },
      { key: 'profile_created_at'               , pg: Profile.columns_hash['created_at'], roles: ['manager', 'admin'] },
      { key: 'profile_updated_at'               , pg: Profile.columns_hash['updated_at'], roles: ['manager', 'admin'] },
      { key: 'posts_count'                      , pg: User.columns_hash['posts_count'], roles: ['manager', 'admin'] },
      { key: 'checks_count'                     , pg: User.columns_hash['checks_count'], roles: ['manager', 'admin'] },
      { key: 'favorites_count'                  , pg: User.columns_hash['favorites_count'], roles: ['manager', 'admin'] },
    ]
  end
end
