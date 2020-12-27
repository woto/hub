# == Schema Information
#
# Table name: post_categories
#
#  id         :bigint           not null, primary key
#  ancestry   :string
#  priority   :integer          default(0), not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  realm_id   :bigint           not null
#
# Indexes
#
#  index_post_categories_on_ancestry  (ancestry)
#  index_post_categories_on_realm_id  (realm_id)
#
# Foreign Keys
#
#  fk_rails_...  (realm_id => realms.id)
#
FactoryBot.define do
  factory :post_category do
    # title_i18n {
    #   I18n.available_locales.each_with_object({}) do |locale, hsh|
    #     I18n.with_locale(locale) do
    #       hsh[locale] = Faker::Commerce.department(max: 2)
    #     end
    #   end
    # }
    title { Faker::Commerce.department(max: 2) }
    realm
  end
end
