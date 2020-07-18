# == Schema Information
#
# Table name: advertisers
#
#  id             :bigint           not null, primary key
#  data           :jsonb
#  last_synced_at :datetime
#  name           :string
#  network        :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  ext_id         :string           not null
#
# Indexes
#
#  index_advertisers_on_network_and_ext_id  (network,ext_id) UNIQUE
#
class Advertiser < ApplicationRecord
  enum network: [ :admitad, :gdeslon ]

  def slug
    [id, ActiveSupport::Inflector.transliterate(name, locale: :ru).parameterize].join('-')
  end
end
