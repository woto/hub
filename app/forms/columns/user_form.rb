# frozen_string_literal: true

module Columns
  class UserForm < BaseForm
    DEFAULTS = %w[id email].freeze

    self.all_columns = [
      { key: 'id'                               , pg: User.columns_hash['id'] },
      { key: 'confirmation_sent_at'             , pg: User.columns_hash['confirmation_sent_at'] },
      { key: 'confirmation_token'               , pg: User.columns_hash['confirmation_token'] },
      { key: 'confirmed_at'                     , pg: User.columns_hash['confirmed_at'] },
      { key: 'current_sign_in_at'               , pg: User.columns_hash['current_sign_in_at'] },
      { key: 'current_sign_in_ip'               , pg: User.columns_hash['current_sign_in_ip'] },
      { key: 'email'                            , pg: User.columns_hash['email'] },
      { key: 'encrypted_password'               , pg: User.columns_hash['encrypted_password'] },
      { key: 'failed_attempts'                  , pg: User.columns_hash['failed_attempts'] },
      { key: 'last_sign_in_at'                  , pg: User.columns_hash['last_sign_in_at'] },
      { key: 'last_sign_in_ip'                  , pg: User.columns_hash['last_sign_in_ip'] },
      { key: 'locked_at'                        , pg: User.columns_hash['locked_at'] },
      { key: 'remember_created_at'              , pg: User.columns_hash['remember_created_at'] },
      { key: 'reset_password_sent_at'           , pg: User.columns_hash['reset_password_sent_at'] },
      { key: 'reset_password_token'             , pg: User.columns_hash['reset_password_token'] },
      { key: 'role'                             , pg: User.columns_hash['role'], as: :string },
      { key: 'sign_in_count'                    , pg: User.columns_hash['sign_in_count'] },
      { key: 'unconfirmed_email'                , pg: User.columns_hash['unconfirmed_email'] },
      { key: 'unlock_token'                     , pg: User.columns_hash['unlock_token'] },
      { key: 'created_at'                       , pg: User.columns_hash['created_at'] },
      { key: 'updated_at'                       , pg: User.columns_hash['updated_at'] },
      { key: 'profile_id'                       , pg: Profile.columns_hash['id'] },
      { key: 'profile_name'                     , pg: Profile.columns_hash['name'] },
      { key: 'profile_time_zone'                , pg: Profile.columns_hash['time_zone'] },
      { key: 'profile_bio'                      , pg: Profile.columns_hash['bio'] },
      { key: 'profile_languages'                , pg: Profile.columns_hash['languages'] },
      { key: 'profile_messengers'               , pg: Profile.columns_hash['messengers'] },
      { key: 'profile_created_at'               , pg: Profile.columns_hash['created_at'] },
      { key: 'profile_updated_at'               , pg: Profile.columns_hash['updated_at'] },
    ]
  end
end
