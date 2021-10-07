# frozen_string_literal: true

# == Schema Information
#
# Table name: realms
#
#  id                    :bigint           not null, primary key
#  domain                :string           not null
#  kind                  :integer          not null
#  locale                :string           not null
#  post_categories_count :integer          default(0), not null
#  posts_count           :integer          default(0), not null
#  title                 :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_realms_on_domain           (domain) UNIQUE
#  index_realms_on_locale_and_kind  (locale,kind) UNIQUE WHERE (kind <> 0)
#  index_realms_on_title            (title) UNIQUE
#
class Realm < ApplicationRecord
  has_logidze ignore_log_data: true

  include Elasticable
  index_name "#{Rails.env}.realms"

  enum kind: { post: 0, news: 1, help: 2 }
  has_many :post_categories
  has_many :posts

  validates :kind, :locale, :title, :domain, presence: true
  validates :kind, uniqueness: { scope: :locale }, unless: :post?
  validates :title, :domain, uniqueness: true

  def to_label
    title
  end

  def as_indexed_json(_options = {})
    {
      id: id,
      domain: domain,
      kind: kind,
      locale: locale,
      post_categories_count: post_categories_count,
      posts_count: posts_count,
      title: title,
      created_at: created_at.utc,
      updated_at: updated_at.utc
    }
  end

  def self.pick(kind:,
                locale:,
                title: "Website: { kind: #{kind}, locale: #{locale} }",
                domain: "#{kind}-#{locale}.lvh.me")
    Realm.find_or_create_by!(locale: locale, kind: kind) do |realm|
      realm.title = title
      realm.domain = domain.downcase
    end
  end
end
