# frozen_string_literal: true

module Columns
  class PostsMapping < BaseMapping
    DEFAULTS = %w[title post_category status amount user_id created_at updated_at].freeze

    self.all_columns = [
      { key: 'realm_id',            pg: Post.columns_hash['realm_id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'realm_title',         pg: Realm.columns_hash['title'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'realm_locale',        pg: Realm.columns_hash['locale'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'realm_kind',          pg: Realm.columns_hash['kind'], as: :string, roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'realm_domain',        pg: Realm.columns_hash['domain'], as: :string, roles: ['manager', 'admin'] },
      { key: 'status',              pg: Post.columns_hash['status'], as: :string, roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'title',               pg: Post.columns_hash['title'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'post_category_id',    pg: Post.columns_hash['post_category_id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'post_category_ids',   pg: Post.columns_hash['post_category_id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'post_category_id_0',  pg: Post.columns_hash['post_category_id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'post_category_id_1',  pg: Post.columns_hash['post_category_id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'post_category_id_2',  pg: Post.columns_hash['post_category_id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'post_category_id_3',  pg: Post.columns_hash['post_category_id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'post_category_id_4',  pg: Post.columns_hash['post_category_id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'post_category_id_5',  pg: Post.columns_hash['post_category_id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'post_category_id_6',  pg: Post.columns_hash['post_category_id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'post_category_id_7',  pg: Post.columns_hash['post_category_id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'post_category_id_8',  pg: Post.columns_hash['post_category_id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'post_category_id_9',  pg: Post.columns_hash['post_category_id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'post_category_title', pg: Post.columns_hash['post_category_id'], as: :string, roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'tags',                pg: Post.columns_hash['tags'], as: :string, roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'intro',               pg: ActionText::RichText.columns_hash['body'], as: :text, roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'body',                pg: ActionText::RichText.columns_hash['body'], as: :text, roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'created_at',          pg: Post.columns_hash['created_at'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'updated_at',          pg: Post.columns_hash['updated_at'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'published_at',        pg: Post.columns_hash['published_at'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'user_id',             pg: Post.columns_hash['user_id'], roles: ['manager', 'admin'] },
      { key: 'amount',              pg: Post.columns_hash['amount'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'currency',            pg: Post.columns_hash['currency'], as: :string, roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'priority',            pg: Post.columns_hash['priority'], roles: ['guest', 'user', 'manager', 'admin'] }
    ]
  end
end
