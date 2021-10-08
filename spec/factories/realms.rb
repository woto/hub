# == Schema Information
#
# Table name: realms
#
#  id                    :bigint           not null, primary key
#  after_body_open       :text
#  after_head_open       :text
#  before_body_close     :text
#  before_head_close     :text
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
FactoryBot.define do
  factory :realm do
    sequence(:title) { |n| "Realm title #{n}" }
    domain { "#{Faker::Alphanumeric.unique.alpha(number: 10)}.lvh.me" }
    locale { I18n.available_locales.sample }
    kind { Realm.kinds.keys.sample }
  end
end
